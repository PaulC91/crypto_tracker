# script executed everyone by cron on Ubuntu cloud server

library(RCrypto)
library(tidyverse)
library(googlesheets)

setwd("/home/paul/crypto/")

new_prices <- RCrypto::CoinMarketCap_Ticker("GBP", c("BTC", "ETH")) %>% 
  mutate(last_updated = as.POSIXct(as.numeric(last_updated), origin = "1970-01-01")) %>%
  mutate_at(vars(contains("price")), as.numeric) %>% 
  select(name, date = last_updated, price_usd, price_gbp) %>% 
  distinct()

googlesheets::gs_auth(token = "shiny_app_token.rds")
sheet_key <- "1T77AEDJxLtb7_sr4nrfyYR9Xkj6w0mMDFKhsMSK-Ykc"

gs_key(sheet_key) %>%
  gs_add_row(input = new_prices, ws = "CoinDB")

rm(new_prices)