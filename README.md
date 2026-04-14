# Budowa i Optymalizacja Portfela Inwestycji Alternatywnych

Projekt naukowy dotyczący wyznaczenia optymalnego portfela inwestycyjnego, łączącego aktywa tradycyjne z alternatywnymi, zrealizowany w ramach kierunku **Analityka Gospodarcza** na **Politechnice Gdańskiej**.

## 📊 O projekcie
Celem projektu było stworzenie struktury portfela, która maksymalizuje zyski przy jednoczesnym ograniczeniu ryzyka. Analiza opiera się na danych historycznych z okresu **01.01.2015 – 31.10.2025**.

### Wykorzystane Instrumenty
W skład portfela weszły cztery zróżnicowane klasy aktywów:
* **Akcje (Tradycyjne):** CD Projekt Red.
* **Waluty:** Para GBP/PLN.
* **Surowce:** Pallad.
* **Fundusze:** ETF S&P 500.

## 🛠️ Metodologia i Narzędzia
Obliczenia zostały wykonane przy użyciu zestawu narzędzi analitycznych:
* **R, Microsoft Excel, Gretl:** Narzędzia wykorzystane do stworzenia tabel, wykresów i optymalizacji portfela.

Do modelowania przyjęto logarytmiczne stopy zwrotu z kapitalizacją ciągłą oraz stopę wolną od ryzyka na poziomie $RF=0,2192\%$.

## 📈 Kluczowe Wyniki

### Analiza Stóp Zwrotu
Poniższy wykres pudełkowy prezentuje rozkład stóp zwrotu dla poszczególnych aktywów. Widoczna jest znacząca przewaga zmienności akcji CD Projekt Red nad stabilnym kursem GBP/PLN.

<img width="800" height="550" alt="wykres pudełkowy" src="https://github.com/user-attachments/assets/f7ba9562-4f30-410e-8929-249eff4efd62" />

### Zbiór Możliwości Inwestycyjnych (ZMI)
Analiza wykazała, że dopuszczenie **krótkiej sprzedaży** fundamentalnie rozszerza obszar dostępnych kombinacji ryzyka i zysku, pozwalając na osiągnięcie wyższej efektywności, dając tym samym szersze możliwości niż model w wariancie klasycznym (tylko długie pozycje).

| Model Long-Only | Model z Krótką Sprzedażą |
| :---: | :---: |
| <img width="1204" height="842" alt="ZMI only long" src="https://github.com/user-attachments/assets/da9c308d-939e-4cee-99ac-e83a0bff15cf" /> | <img width="1204" height="842" alt="ZMI ss" src="https://github.com/user-attachments/assets/29e0b2bf-3a58-43ee-8d8b-28f16910708b" /> |

### Skład Portfeli z Granicy Efektywnej
Wykres przedstawia ewolucję wag w portfelu w zależności od założonego celu inwestycyjnego. Wraz ze wzrostem oczekiwanego zwrotu, portfel odchodzi od bezpiecznego funta brytyjskiego (GBP) na rzecz instrumentów bardziej ryzykownych, w tym ETF S&P 500 oraz akcji CD Projekt Red.

<img width="800" height="550" alt="portfele z granicy efektywnej" src="https://github.com/user-attachments/assets/58af2f88-5873-4863-8606-019219f2393b" />

## 🏆 Podsumowanie Efektywności
* **Portfel Minimalnego Ryzyka:** Ryzyko 2,22%, stopa zwrotu 0,07%. Zdominowany przez GBP (86%).
* **Portfel Maksymalnej Efektywności:** Ryzyko 4,31%, stopa zwrotu 1,27%. Główny udział posiada ETF S&P 500 (74%).
