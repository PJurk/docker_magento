# Magento 2.4 Docker Compose setup on Windows 10

## Wymagania

* Zainstalowany i aktywowany [WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install-win10#update-to-wsl-2 "Instrukcja instalacji WSL 2")

* Zainstalowana w WSL 2 dystrybucja linuksa Debian albo Ubuntu

* Zainstalowany [Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows "Docker Desktop") i aktywowany w wybranej dystrybucji [instrukcja](https://docs.docker.com/docker-for-windows/wsl/ "Instrukcja aktywacji")


## Instalacja

Sklonuj albo pobierz repozytorium w wybranej dystrybucji

    git clone https://github.com/PJurk/docker_magento.git

Używając [VSCode albo PHPStorm][Praca Zdalna] połącz się z WSL i otwórz folder projektu.

W pliku `env` dodaj klucze z Magento Marketplace w pola `PUBLIC_KEY` i `PRIVATE_KEY`

Do pliku `hosts` w Windowsie dodaj wpis

    127.0.0.1 magento.test.com

Uruchom skrypt instalacji

    sudo bash start.sh

Docker zbuduje obrazy, aktywuje kontenery, pobierze i zainstaluje Magento 2.4. Z względu na dużą ilość plików do pobrania to chwilę zajmie. 

Po skończeniu instalacji magento będzie dostępnie pod adresem `magento.test.com`, a panel administratorski `magento.text.com/admin`.
PHPMyAdmin będzie dostępne pod adresem `magento.test.com:8580`.

## Użytkowanie

[Praca zdalna]: # 
Do pracy z Magento trzeba połączyć się z dystrybucją linuksa w WSL. VSCode i PHPStorm zapewniają narzędzia do takiej pracy.

* [PHPStorm z WSL](https://blog.jetbrains.com/phpstorm/2020/06/phpstorm-2020-1-2-is-released/ "Instrukcja połączenia z WSL w PHPStorm")
* [VSCode z WSL](https://code.visualstudio.com/docs/remote/wsl-tutorial "Instrukcja połączenia z WSL w VSCode")

W celu używania CLI Magento trzeba użyć komendy:

    docker exec -it my-magento bin/magento {komenda}

Można też połączyć się z konsolą w kontenerze:
    
    docker exec -it my-magento bash

Tak można używać komend bezpośrednio w kontenerze, można wyjść z niego komendą:
    
    exit

Po skończonej pracy kontenery można wyłączyć komendą

    docker-compose down

## Konfiguracja


Zmienne instalacyjne możesz dostosowywać zmieniając je w pliku `env`.
Wszystkie aktywne serwisy możesz podejrzeć w pliku `docker-compose.yml` wraz z wystawionymi przez nie portami.

Do aktywacji MFTF w Magento możesz użyć skryptu `mftf.sh`.

W celu zmiany adresu sklepu przed instalacją trzeba go zmienić w pliku `env` oraz plikach konfiguracji Apache w folderze `Docker/Magento`.

Jeśli zmieniamy adres po instalacji to trzeba zmodyfikować pliki Apache. Następnie należy zbudować obrazy Dockera na nowo komendą
    
    docker-compose build
I zmienić adres sklepu w konfiguracji Magento.

Porty zmapowane z portami na naszym komputerze można zmienić w pliku `docker-compose.yml`.
