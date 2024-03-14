
#!/bin/bash

# Ajout de la date et l'heure actuelles au nom du fichier de rapport
CURRENT_DATETIME=$(date "+%Y-%m-%d_%H-%M-%S")
REPORT_FILE="network_report_$CURRENT_DATETIME.txt"

# En-tête du rapport
echo "Génération du rapport des paramètres réseau pour Raspberry Pi..."
echo "Rapport des paramètres réseau pour Raspberry Pi" > $REPORT_FILE
echo "-------------------------------------------------" >> $REPORT_FILE
date >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Check if wifi is enabled
if iwconfig wlan0 | grep -q "no wireless extensions."; then
  echo "Wi-Fi est désactivé, activation en cours..."
  sudo ifconfig wlan0 up
else
  echo "Wi-Fi est activé."
fi


# Informer l'utilisateur de ce qui est en cours
echo "Scanning des réseaux Wi-Fi disponibles..."
# Scan des réseaux Wi-Fi et construction d'un tableau
echo "Scan des réseaux Wi-Fi disponibles :" >> $REPORT_FILE
echo "ESSID                               | Fréquence              |    Qualité" >> $REPORT_FILE
echo "------------------------------------|--------------------------|--------" >> $REPORT_FILE
sudo iwlist wlan0 scan | awk -F':' '/ESSID/{essid=$2} /Frequency/{freq=$2} /Quality/{qual=$0; gsub(/.*Quality=| Signal.*$/, "", qual); printf "%-35s | %-24s | %s\n", essid, freq, qual}' >> $REPORT_FILE
echo "Scan Wi-Fi terminé."

echo "" >> $REPORT_FILE

# État de l'interface Wi-Fi
echo "Affichage de l'état actuel de la connexion Wi-Fi..."
echo "État actuel de la connexion Wi-Fi :" >> $REPORT_FILE
iwconfig wlan0 >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Qualité du signal Wi-Fi
echo "Analyse de la qualité du signal Wi-Fi..."
echo "Qualité du signal Wi-Fi :" >> $REPORT_FILE
iwconfig wlan0 | grep -E "Link Quality|Signal level" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Test de ping pour déterminer le taux de perte de paquets
echo "Réalisation d'un test de ping pour déterminer le taux de perte de paquets..."
echo "Test de ping (taux de perte de paquets) :" >> $REPORT_FILE
ping -c 50 8.8.8.8 | tail -n 2 >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Check if bluetooth is enabled
if hciconfig -a | grep -q "DOWN"; then
  echo "Bluetooth est désactivé, activation en cours..."
  sudo hciconfig hci0 up
else
  echo "Bluetooth est activé."
fi

# Appareils Bluetooth disponibles
echo "Recherche des appareils Bluetooth à proximité..."
echo "Appareils Bluetooth à proximité :" >> $REPORT_FILE
sudo hcitool scan >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Afficher le rapport
echo "Rapport généré dans $REPORT_FILE"
