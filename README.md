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

![Wykres pudełkowy](wykres%20pudełkowy.png)

### Zbiór Możliwości Inwestycyjnych (ZMI)
Analiza wykazała, że dopuszczenie **krótkiej sprzedaży** fundamentalnie rozszerza obszar dostępnych kombinacji ryzyka i zysku, pozwalając na osiągnięcie wyższej efektywności, dając tym samym szersze możliwości niż model w wariancie klasycznym (tylko długie pozycje).

| Model Long-Only | Model z Krótką Sprzedażą |
| :---: | :---: |
| ![ZMI Long Only](ZMI%20only%20long.png) | ![ZMI Short Selling](ZMI%20ss.png) |

### Skład Portfeli z Granicy Efektywnej
Wykres przedstawia ewolucję wag w portfelu w zależności od założonego celu inwestycyjnego. Wraz ze wzrostem oczekiwanego zwrotu, portfel odchodzi od bezpiecznego funta brytyjskiego (GBP) na rzecz instrumentów bardziej ryzykownych, w tym ETF S&P 500 oraz akcji CD Projekt Red.

![Granica efektywna](portfele%20z%20granicy%20efektywnej.png)

## 🏆 Podsumowanie Efektywności
* **Portfel Minimalnego Ryzyka:** Ryzyko 2,22%, stopa zwrotu 0,07%. Zdominowany przez GBP (86%).
* **Portfel Maksymalnej Efektywności:** Ryzyko 4,31%, stopa zwrotu 1,27%. Główny udział posiada ETF S&P 500 (74%).
