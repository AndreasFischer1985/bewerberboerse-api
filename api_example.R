#----------------
# Simple Example
#----------------
install.packages(c("devtools","rjson","httr"))
devtools::install_github("AndreasFischer1985/qqBaseX")
clientId="919b0af7-6e5f-4542-a7f5-04268b8bae2e"
clientSecret="93fce94c-5be2-4dc8-b040-c62818a4b003"

postData=list( "grant_type"="client_credentials","client_id"=clientId,"client_secret"=clientSecret) 
token_request=httr::POST(
        url="https://rest.arbeitsagentur.de/oauth/gettoken_cc",
        body=postData,encode="form",
        config=httr::config(connecttimeout=60))
token=httr::content(token_request, as='parsed')$access_token
url="https://rest.arbeitsagentur.de/jobboerse/bewerbersuche-service/pc/v1/bewerber?angebotsart=ar&wo=Feucht&umkreis=0&page=0&size=25"
data_request=httr::GET(url=url, httr::add_headers(.headers=c("OAuthAccessToken"=token)),
        config=httr::config(connecttimeout=60))
data_request
data=httr::content(data_request)


