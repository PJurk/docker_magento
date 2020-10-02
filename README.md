# Magento 2.4 Docker Compose setup on Windows 10

## Wymagania

* Zainstalowany i aktywowany [WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10#update-to-wsl-2 "Instrukcja instalacji WSL 2")

* Zainstalowana w WSL 2 dystrybucja linuksa Debian albo Ubuntu

* Zainstalowany [Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows "Docker Desktop") i aktywowany w wybranej dystrybucji: [Instrukcja](https://docs.docker.com/docker-for-windows/wsl/ "Instrukcja aktywacji")

## Instalacja

Sklonuj albo pobierz repozytorium w wybranej dystrybucji

    git clone https://github.com/PJurk/docker_magento.git

Domyślnie instaluje się Magento 2.4.0, w celu zainstalowania Magento 2.3.5 sklonuj branch:

    git clone --branch Magento-2.3.5 https://github.com/PJurk/docker_magento.git

Używając [VSCode albo PHPStorm](#Użytkowanie) połącz się z WSL i otwórz folder projektu.

### Nowa instalacja Magento 2

W pliku `env` dodaj klucze z Magento Marketplace w pola `PUBLIC_KEY` i `PRIVATE_KEY`

Do pliku `hosts` w Windowsie dodaj wpis

    127.0.0.1 magento.test.com

Uruchom skrypt instalacji

    sudo bash start.sh

Docker zbuduje obrazy, aktywuje kontenery, pobierze i zainstaluje Magento 2.4. Z względu na dużą ilość plików do pobrania to chwilę zajmie.

Po skończeniu instalacji magento będzie dostępnie pod adresem `magento.test.com`, a panel administratorski `magento.text.com/admin`.
PHPMyAdmin będzie dostępne pod adresem `magento.test.com:8580`.

### Ustawienie instniejącego projektu

Jeżeli masz gotowy projekt i nie chcesz instalować nowego sklepu Magento, nie musisz używać skryptu `start.sh`.

Do folderu `/Docker/Magento` dodaj plik auth.json z kluczami z Magento Marketplace.

Dostosuj adres sklepu w [plikach konfiguracji Apache](#konfiguracja), dodaj adres do pliku `hosts`, następnie włącz i zbuduj kontenery komendą:

    docker-compose up --build -d

I do folderu `/app` skopiuj pliki z używanego projektu Magento 2 i z pomocą `PHPMyAdmin` zaimportuj używaną bazę danych.

## Użytkowanie

### XDEBUG

Do działania XDEBUG trzeba przed włączeniem kontenerów dockera zmienić IP hosta w pliku `docker-compose.yml`

      XDEBUG_CONFIG: "remote_host={IP}" 

#### Dla VS Code

Komenda generująca obecne IP WSL2

    hostname -I 

Z każdym włączeniem WSL2 otrzymuje nowe IP
maszyny wirutalnej. Stąd potrzeba jego poprawy.

#### Dla PHPStorm

Remote Host ustaw na
    
    remote_host=host.docker.internal

W ustawieniach PHP Storm: Setting > PHP|Server, dla adresu strony włącz mapowanie ścieżek.

### Praca z WSL 2

Do pracy z Magento trzeba połączyć się z dystrybucją linuksa w WSL. VSCode i PHPStorm zapewniają narzędzia do takiej pracy.

* [PHPStorm z WSL](https://blog.jetbrains.com/phpstorm/2020/06/phpstorm-2020-1-2-is-released/ "Instrukcja połączenia z WSL w PHPStorm")
* [VSCode z WSL](https://code.visualstudio.com/docs/remote/wsl-tutorial "Instrukcja połączenia z WSL w VSCode")

Magento do pracy będzie się znajdowało w folderze `app`, wszystkie zmiany wprowadzone w tym folderze są odzwierciedlane w kontenerze. Tak samo wszelkie zmiany w plikach w kontenerze będą odzwierciedlone w tym folderze.
Folder `db` zawiera zapisaną bazę danych.

### Dostęp do konsoli Magento 2

W celu używania CLI Magento trzeba użyć komendy:

    docker exec -it my-magento bin/magento {komenda}

Można też połączyć się z konsolą w kontenerze:
    
    docker exec -it my-magento bash

Tak można używać komend bezpośrednio w kontenerze, można wyjść z niego komendą:
    
    exit

Po skończonej pracy kontenery można wyłączyć komendą

    docker-compose down
    
 
Po instalacji nie musimy używać skryptu `start.sh` włączamy system komendą 
    
    docker-compose up -d

Flaga `-d` nie zablokuje tam terminala do dalszej pracy. Bez niej w konsoli będą wyświetlane logi z kontenerów.

### Pliki w WSL 2

Możesz uzyskać dostęp do plików w WSL 2 otwierając w nim Windows explorer:

* Używając w folderze WSL komendy `explorer.exe .`
* Wpisując w explorerze ścieżkę `\\$wsl\`

## Konfiguracja

Zmienne instalacyjne możesz dostosowywać zmieniając je w pliku `env`.
Wszystkie aktywne serwisy możesz podejrzeć w pliku `docker-compose.yml` wraz z wystawionymi przez nie portami.

Do aktywacji MFTF w Magento możesz użyć skryptu `mftf.sh`.

W celu zmiany adresu sklepu przed instalacją trzeba go zmienić w pliku `env`, plikach konfiguracji Apache w folderze `Docker/Magento`, dostosować nazwy plików, instrukcje COPY w dockerfile i dodać adres to pliku hosts na komputerze.

    magento.test.com.conf >> moj.adres.strony.conf

Wewnatrz pliku  moj.adres.strony.conf i apache2.conf linijke SERVER NAME

    www.magento.test.com >> moj.adres.strony.conf

I wewnatrz pliku Dockerfile w miejscach oznaczonych komentarzem

Jeśli zmieniamy adres po instalacji to trzeba zbudować obrazy Dockera na nowo komendą
    
    docker-compose build
    
I zmienić adres sklepu w konfiguracji Magento.

Porty zmapowane z portami na naszym komputerze i połączone foldery można zmienić w pliku `docker-compose.yml`.
