#!/bin/bash

cert=CAEntrate.cer
certurl=https://tooshi.sumorize.com/sites/tooshi/files/CAEntrate.cer
aeurl=https://apid-ivaservizi.agenziaentrate.gov.it/v1/dispositivi/corrispettivi/

xml=$1

[ "X$xml" = "X" ] && echo -e "Nessun xml specificato.\n\nUtilizzo:\n$0 xml-file" && exit

# [ ! -e ./CAEntrate.cer ] && (echo "Certificato non trovato, lo scarico" && wget -q --no-check-certificate $certurl && echo "Certificato scaricato: $certurl") || echo "Utilizzo certificato: $cert"

[ ! -e ./CAEntrate.cer ] && (echo "Certificato non trovato, lo scarico" && curl -s $certurl -o $cert && echo "Certificato scaricato: $certurl") || echo "Utilizzo certificato: $cert"

echo "Invio xml: $xml"
read -p "Confermi invio? " -n 1 -r
echo
if [[ $REPLY =~ ^[YySs]$ ]]
then
	echo "Invio confermato"
	echo
	curl -vvv -H "Content-Type: application/xml" --tlsv1.2 --cacert ./$cert $aeurl --data-binary @$xml >> $xml.esito.xml  
	echo
fi
