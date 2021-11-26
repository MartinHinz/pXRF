---
title: "basic_functionality"
output:
  html_document:
    keep_md: true
  rmarkdown::html_vignette:
vignette: >
  %\VignetteIndexEntry{basic_functionality}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




```r
library(pXRF)
```

# Reading Data

Wir gehen davon aus, dass die initialen Daten für die weiteren Schritte in Form von CSV Dateien vorliegen, die aus dem NDT Programm exportiert, und dann in Excel in CSV Dateien umgewandelt worden sind. Als erstes müssen wir den Pfad angeben, von dem wir die Datei importieren möchten.


```r
# Durch interaktive Wahl des Benutzers
#source_csv <- file.choose()

# Oder durch einen fest angestellten Pfad
source_csv <- "../inst/extdata/pxrf_example_data.csv"
```

Von diesem Pfad nun können wir die Datei einladen. Zu beachten ist, Das in der CSV Datei durch den Export von der NDT-Software Elemente, die unter der Erfassungsgrenze lagen, durch "< LOD" gekennzeichnet sind. Dieses ist eine im R nicht auswertbare Angabe. Zudem führt diese Angabe dazu, dass die einzelnen Elemente-Spalten als Text eingeladen werden. Um dies zu beheben, müssen wir den Eintrag ersetzen, und dann die entsprechenden Spalten als Zahlenspalten kennzeichnen.

Diese Ersetzung kann unterschiedlich geschehen. Entweder können wir die Angabe durch NA (d.h., dass wir keine Informationen über dieses Datum haben) ersetzen. Für unsere Zwecke ist es jedoch meistens sinnvoller, die sind wird dann auf null zu setzen, da dies der Natur der Angabe besser entspricht, und so die Spalten für eine weitere numerische Auswertung zur Verfügung stehen.

Zudem gibt es zwei Versionen von CSV Dateien. Entweder ist der Dezimaltrenner ein ",", dann werden Spalten normalerweise durch ein ";" getrennt. Dies ist die europäische Version des CSV Datei. Anderenfalls ist der Dezimaltrenner ein Punkt ("."), Wie ist in der angloamerikanischen Version der Fall ist. In dem Fall ist der Dezimaltrenner ein ",". Diese Angaben müssen im Skript gegebenenfalls geändert werden, falls der Import nicht korrekt funktioniert.


```r
# Dezimaltrenner und Spaltentrenner festlegen, und wodurch "< LOD" ersetzt werden soll
dec <- ","
sep <- ";"
lod <- 0.0

# Elemente- und Oxidnamen laden
data("elements")
data("oxides")

# Die eigentlichen Daten laden
pxrf_data <- read.csv(source_csv, dec = dec, sep = sep, na.strings = "< LOD")

# Feststellen, welche Spalten Element- und Oxidinformationen beinhalten
element_columns <- colnames(pxrf_data)[colnames(pxrf_data) %in% elements$symbol]
element_error_columns <- colnames(pxrf_data)[colnames(pxrf_data) %in% elements$error]
oxide_columns <- colnames(pxrf_data)[colnames(pxrf_data) %in% oxides$symbol]
oxide_error_columns <- colnames(pxrf_data)[colnames(pxrf_data) %in% oxides$error]

# Aus diesen setzt sich der eigentliche Datenbereich zusammen
data_columns <- c(element_columns, element_error_columns, oxide_columns, oxide_error_columns)

# Alles andere zählt zu den Meta-Daten
meta_columns <- colnames(pxrf_data)
meta_columns <- meta_columns[!(meta_columns %in% data_columns)]

# "< LOD" durch den Eintrag von oben ersetzen
pxrf_data[data_columns][is.na(pxrf_data[data_columns])] <- lod
```
Als Nächstes ist im Falle von Keramik Daten (Messmodus Mineralien) eine Feinkalibration durch zu führen, basierend auf der Kalibration, wie sie mittels eines stationären XRF-Apparatur für unser Gerät erstellt wurde. Diese beinhaltet nicht alle möglichen Elemente, sondern nur eine Auswahl:


```r
elements_fine_calibration <- c("Nb","Zr","Y","Sr","Rb","Th","Pb","Zn","Cu","Ni","Fe","Mn","Cr","V","Ti","Ba","Ca","K","Al","P","Si","S","Mg")
pxrf_data.fine_calibration <- pxrf_data[elements_fine_calibration]
```


Die Faktoren hierfür können individuell für die einzelnen Elemente zugeordnet werden:


```r
pxrf_data.fine_calibration$Nb <-  pxrf_data.fine_calibration$Nb * 0.95
pxrf_data.fine_calibration$Zr <- pxrf_data.fine_calibration$Zr * 1
pxrf_data.fine_calibration$Y <- pxrf_data.fine_calibration$Y * 1.3
pxrf_data.fine_calibration$Sr <- pxrf_data.fine_calibration$Sr * 1
pxrf_data.fine_calibration$Rb <- pxrf_data.fine_calibration$Rb * 1.03
pxrf_data.fine_calibration$Th <- pxrf_data.fine_calibration$Th * 1.77
pxrf_data.fine_calibration$Pb <- pxrf_data.fine_calibration$Pb * 1.24 #ACHTUNG: Pb erst ab ca. 30ppm gut gemessen !
pxrf_data.fine_calibration$Zn <- pxrf_data.fine_calibration$Zn * 1.07
pxrf_data.fine_calibration$Cu <- pxrf_data.fine_calibration$Cu * 1.18
pxrf_data.fine_calibration$Ni <- pxrf_data.fine_calibration$Ni * 1.21
pxrf_data.fine_calibration$Fe <- pxrf_data.fine_calibration$Fe * 1.04
pxrf_data.fine_calibration$Mn <- pxrf_data.fine_calibration$Mn * 1.23
pxrf_data.fine_calibration$Cr <- pxrf_data.fine_calibration$Cr * 0.8
pxrf_data.fine_calibration$V <- pxrf_data.fine_calibration$V * 1
pxrf_data.fine_calibration$Ti <- pxrf_data.fine_calibration$Ti * 1
pxrf_data.fine_calibration$Ba <- pxrf_data.fine_calibration$Ba * 0.73
pxrf_data.fine_calibration$Ca <- pxrf_data.fine_calibration$Ca * 1.05
pxrf_data.fine_calibration$K <- pxrf_data.fine_calibration$K * 1.05
pxrf_data.fine_calibration$Al <- pxrf_data.fine_calibration$Al * 0.91
pxrf_data.fine_calibration$P <- pxrf_data.fine_calibration$P * 1
pxrf_data.fine_calibration$Si <- pxrf_data.fine_calibration$Si * 1.06
pxrf_data.fine_calibration$S <- pxrf_data.fine_calibration$S * 1.3
pxrf_data.fine_calibration$Mg <- pxrf_data.fine_calibration$Mg * 0.78
```

Alternativ kann man auch eine im Rahmen dieses Paketes entwickelte Kurzfunktion nutzen


```r
pxrf_data.fine_calibration2 <- pXRF::fine_calibration_mineral(pxrf_data)
```
Nun sollte man noch die Meta-Daten aus dem ursprünglichen Datensatz hinzufügen


```r
pxrf_data.fine_calibration2[,meta_columns] <- pxrf_data[,meta_columns]
```


Jetzt können wir die Daten zwischenzeitlich abspeichern


```r
write.csv(pxrf_data.fine_calibration2, "data_feinkalibriert.csv")
```

Jetzt legen wir fest, welches die Haupt- und welches die Spurenelemente für unsere Untersuchung sind. Diese Listen sind ggf. zu ändern:


```r
pxrf_data.main_elements<-pxrf_data.fine_calibration2[,c("Si","Ti","Al","Fe","Mn","Mg","Ca","K","P")]  # Gleiche die Fribourg verwendet. Evt. Auswahl treffen je nach Sample
pxrf_data.trace_elements<-pxrf_data.fine_calibration2[,c("Nb","Zr","Y","Sr","Rb","Th","Pb","Zn","Cu","Ni","Cr","V","Ba","S")] # Evt. Auswahl z.B. Cu und S weglassen
```

Desweiteren können wir nun die Oxide mittels Transformationsfaktoren berechnen:


```r
pxrf_data.oxide <- data.frame(
  matrix(
    nrow = nrow(pxrf_data),
    ncol=nrow(oxides)
    )
)
colnames(pxrf_data.oxide) <- oxides$symbol

pxrf_data.oxide$SiO2<-pxrf_data.main_elements$Si*2.1392
pxrf_data.oxide$TiO2<-pxrf_data.main_elements$Ti*1.6681
pxrf_data.oxide$Al2O3<-pxrf_data.main_elements$Al*1.8895
pxrf_data.oxide$Fe2O3<-pxrf_data.main_elements$Fe*1.4297
pxrf_data.oxide$MnO<-pxrf_data.main_elements$Mn*1.2912
pxrf_data.oxide$MgO<-pxrf_data.main_elements$Mg*1.6582
pxrf_data.oxide$CaO<-pxrf_data.main_elements$Ca*1.3992
pxrf_data.oxide$K2O<-pxrf_data.main_elements$K*1.2046
pxrf_data.oxide$P2O5<-pxrf_data.main_elements$P*2.2916
pxrf_data.oxide$Sum<-apply(pxrf_data.oxide,1,sum,na.rm=T)
```
Diese Oxidanteile können nun noch auf normierte Gewichtsprozente umgerechnet werden:


```r
pxrf_data.wt_oxide <- pxrf_data.oxide/pxrf_data.oxide$Sum * 100
colnames(pxrf_data.wt_oxide) <- paste0(colnames(pxrf_data.wt_oxide), "_wt")
```

und wieder die Metadaten hinzufügen


```r
pxrf_data.oxide[,meta_columns] <- pxrf_data[,meta_columns]
pxrf_data.wt_oxide[,meta_columns] <- pxrf_data[,meta_columns]
```


und diese Daten können wir nun ebenfalls absichern


```r
write.csv(pxrf_data.oxide, "oxide.csv")
write.csv(pxrf_data.wt_oxide, "oxide_wt.csv")
```
