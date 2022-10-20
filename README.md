# Arbeitsagentur Bewerberbörse API 
Die Bundesagentur für Arbeit verfügt über eine der größten Datenbanken für Bewerber*innen in Deutschland. Obwohl sie vollständig staatlich ist und es sich dabei um einen sehr spannenden Basisdatensatz handelt, mit dem viele Analysen möglich wären, bietet die Bundesagentur für Arbeit dafür bis heute keine offizielle API an.


## Authentifizierung
Die Authentifizierung funktioniert per OAuth 2 Client Credentials mit JWTs.
Client Credentials sind, wie https://www.arbeitsagentur.de/bewerberboerse/config/config.js zu entnehmen ist, folgende:

**client_id:** 919b0af7-6e5f-4542-a7f5-04268b8bae2e

**client_secret:** 93fce94c-5be2-4dc8-b040-c62818a4b003

**grant_type:** client_credentials

Die Credentials sind im body eines POST-request an https://rest.arbeitsagentur.de/oauth/gettoken_cc zu senden.

```bash
token=$(curl \
-d "client_id=919b0af7-6e5f-4542-a7f5-04268b8bae2e&client_secret=93fce94c-5be2-4dc8-b040-c62818a4b003&grant_type=client_credentials" \
-X POST 'https://rest.arbeitsagentur.de/oauth/gettoken_cc' |grep -Eo '[^"]{400,}'|head -n 1)
```

Der generierte Token muss bei folgenden GET-requests an https://rest.arbeitsagentur.de/jobboerse/bewerbersuche-service/pc/v1/bewerber im header als 'OAuthAccessToken' inkludiert werden.


## Bewerbendenbörse

**URL:** https://rest.arbeitsagentur.de/jobboerse/bewerbersuche-service/pc/v1/bewerber

Die Bewerberbörse ermöglicht es, Bewerber*innen mit verschiedenen GET-Parametern zu filtern. 


**Parameter:** *was* (Optional)

Beruf, Kenntnisse, Sprachen, etc.


**Parameter:** *ausbildungsart* (Optional)

- au
- dsa
- dsp

Ausbildungsart: au=Ausbildung, dsa=Duales Studium (ausbildungsintegrierend), dsp=Duales Studium (praxisintegrierend).


**Parameter:** *wo* (Optional)

Ort, PLZ, Bundesland, Land, etc.


**Parameter:** *umkreis* (Optional)

- 0
- 10
- 15
- 20
- 50
- 100
- 200

Umkreis: 0=ganzer Ort; 10=10km; 15=15km; 20=20km; 50=50km; 100=100km; 200=200km.


**Parameter:** *angebotsart* (Optional)

- ar
- au
- pt
- se

Angebotsart: ar=Arbeitskräfte; au=Auszubildende/Duales Studium; pt=Praktikanten/Trainees; se=Selbstständige.


**Parameter:** *arbeitszeit* (Optional)

- vz
- tz
- snw

Arbeitszeit: vz=Vollzeit; tz=Teilzeit; snw=Schicht,Nacht,Wochenende; ht=Heim-/Telearbeit; mj=Minijob.


**Parameter:** *berufserfahrung* (Optional)

- be
- mb

Berufserfahrung: be=Berufseinsteiger*innen; mb=Mit Berufserfahrung.


**Vertragsart:** *vertragsart* (Optional)

- be
- ub

Vertragsart: be=Befristet; ub=Unbefristet.


**Parameter:** *behinderung* (Optional)

- an

Behinderung: an=Nur Schwerbehinderte oder ihnen gleichgestellte Bewerber*innen anzeigen.


**Parameter:** *page* (Optional)

Seite (beginnend bei 0).


**Parameter:** *size* (Optional)

Anzahl der Ergebnisse


### Beispiel:


```bash
bewerbende=$(curl -m 60 \
-H "OAuthAccessToken: $token" \
'https://rest.arbeitsagentur.de/jobboerse/bewerbersuche-service/pc/v1/bewerber?angebotsart=ar&wo=Feucht&umkreis=0&page=0&size=25')
```


## Bewerbendendetails

**URL:** https://rest.arbeitsagentur.de/jobboerse/bewerbersuche-service/pc/v1/bewerberdetails/{Referenznummer}

Details zu einzelnen Bewerbenden lassen sich unter Angabe der Referenznummer (z.B. 10005-955011998040991647-B) abfragen,
u.a. Bildungshistorie, beruflicher Werdegang, Lizenzen, Kenntnisse & Skills.

### Beispiel:


```bash
bewerbendendetails=$(curl -m 60 \
-H "OAuthAccessToken: $token" \
'https://rest.arbeitsagentur.de/jobboerse/bewerbersuche-service/pc/v1/bewerberdetails/10005-955011998040991647-B')
```
