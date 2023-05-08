import requests
from requests import ReadTimeout
import pandas as pd
import numpy as np
#from config import *
import time
import hashlib
import hmac
    #=======================FUNCTIONS=======================

def concatenate_data(*dataframes):
    return pd.concat(dataframes, axis=0, ignore_index=True)


def merge_all_data(all_data_buy, all_data_sell):
    # Sort the first dataframe by price in ascending order
    all_data_buy_sorted = all_data_buy.sort_values(by='price')
    all_data_buy_sorted = all_data_buy_sorted.reset_index(drop=True)
    all_data_buy_sorted = all_data_buy_sorted.rename(columns={
            'currency': 'currency_buy',
            'payment': 'payment_buy',
            'price': 'price_buy',

    })

    # Sort the second dataframe by price in descending order
    all_data_sell_sorted = all_data_sell.sort_values(by='price', ascending=False)
    all_data_sell_sorted = all_data_sell_sorted.reset_index(drop=True)
    all_data_sell_sorted = all_data_sell_sorted.rename(columns={
            'currency': 'currency_sell',
            'payment': 'payment_sell',
            'price': 'price_sell',

    })

    # Merge the two dataframes by concatenating them horizontally
    merged_data = pd.concat([all_data_buy_sorted, all_data_sell_sorted], axis=1)
    return merged_data



def spret(df):  
    df['spret'] = df['price_sell'].astype(float) / df['price_buy'].astype(float)-1
    return df.head(5)





def save_to_csv(coin, df):
    filename = f"{coin}.csv"
    df.to_csv(filename, index=False)
    print(f"Dataframe saved as {filename}")


    #=======================END_OF_FUNCTIONS=======================


    #=======================HUOBI=======================  
import requests
import pandas as pd


#Huobi SELL
def get_huobi_data_sell(coin, method):
    url = 'https://otc-api.trygofast.com/v1/data/trade-market?coinId={coin}&currency=11&tradeType=buy&currPage=1&payMethod={method}&acceptOrder=-1&country=&blockType=general&online=1&range=0&amount=&isThumbsUp=false&isMerchant=true&isTraded=false&onlyTradable=false&isFollowed=false'.format(coin=coin,method=method)

    headers = {
        'access_control_allow_credentials': "true",
        'access_control_allow_origin': "https://www.huobi.com",
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
    }

    params = {
        "coinId": coin,
        "currency": "11",
        "tradeType": "buy",
        "currPage": "1",
        "payMethod": [method],
        "blockType": "general",
        "amount": "",
        "isMerchant": "true"
    }

    response = requests.get(url).json()

    #Return
    prices =  [response['data'][0]['price']]
            #response['data'][1]['price'], 
            #response['data'][2]['price']

    if method == 28:
        method = 'tinkoff'
    elif method == 29:
        method = 'rosbank'



    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'Huobi', 
                       'payment': method, 
                       'price': prices})

    # Return the DataFrame
    return df


    
#Huobi BUY   
def get_huobi_data_buy(coin, method):

    url = 'https://otc-api.trygofast.com/v1/data/trade-market?coinId={coin}&currency=11&tradeType=sell&currPage=1&payMethod={method}&acceptOrder=0&country=&blockType=general&online=1&range=0&amount=&isThumbsUp=false&isMerchant=true&isTraded=false&onlyTradable=false&isFollowed=false'.format(coin=coin,method=method)

    headers = {
        'access_control_allow_credentials': "true",
        'access_control_allow_origin': "https://www.huobi.com",
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
    }

    params = {
    "coinId": coin,
    "currency": "11",
    "tradeType": "sell",
    "currPage": "1",
    "payMethod": [method],
    "country": "",
    "blockType": "general",
    "isMerchant": "true",
    "amount": ""
    }

    response = requests.get(url).json()

    #Return
    prices =  [response['data'][0]['price']]
            #response['data'][1]['price'], 
            #response['data'][2]['price']]

    if method == 28:
        method = 'tinkoff'
    elif method == 29:
        method = 'rosbank'



    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'Huobi', 
                       'payment': method, 
                       'price': prices})

    # Return the DataFrame
    return df

    #=======================END_OF_HUOBI=======================


    #=======================BINANCE=======================
#Binance SELL
def get_binance_data_sell(coin, method):
    url = 'https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search'

    headers = {
        'accept': '*/*',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
    }

    params = {
    "proMerchantAds": False,
    "page": 1,"rows": 10,
    "payTypes": method,
    "countries": ["RU"],
    "publisherType": "merchant",
    "transAmount": "",
    "tradeType": "SELL",
    "asset": coin,
    "fiat": "RUB"
    }

    response = requests.post(url=url, headers=headers, json=params).json()

    prices = [response['data'][0]['adv']['price'], 
            response['data'][1]['adv']['price'], 
            response['data'][2]['adv']['price']]


    if method == ["TinkoffNew"]:
        method = 'tinkoff'
    elif method == ['RosBankNew']:
        method = 'rosbank'



    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'Binance', 
                       'payment': method, 
                       'price': prices})

    # Return the DataFrame
    return df




#Binance BUY
def get_binance_data_buy(coin, method):
    url = 'https://p2p.binance.com/bapi/c2c/v2/friendly/c2c/adv/search'

    headers = {
        'accept': '*/*',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
    }

    params = {
    "proMerchantAds": False,
    "page": 1,"rows": 10,
    "payTypes": method,
    "countries": ["RU"],
    "publisherType": "merchant",
    "asset": coin,
    "fiat": "RUB",
    "tradeType": "BUY"
    }

    response = requests.post(url=url, headers=headers, json=params).json()

    #Return
    prices = [response['data'][0]['adv']['price'], 
            response['data'][1]['adv']['price'], 
            response['data'][2]['adv']['price']]


    if method == ["TinkoffNew"]:
        method = 'tinkoff'
    elif method == ['RosBankNew']:
        method = 'rosbank'



    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'Binance', 
                       'payment': method, 
                       'price': prices})

    # Return the DataFrame
    return df


    #=======================END_OF_BINANCE=======================


    #=======================BYBIT=======================
def get_bybit_data_buy(coin, payment):
    url = 'https://api2.bybit.com/fiat/otc/item/online'

    headers = {
        'accept': 'application/json',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
    }

    params = {
    "userId": "",
    "tokenId": coin,
    "currencyId": "RUB",
    "payment": payment,
    "side": "1",
    "size": "10",
    "page": "1",
    "authMaker" : True    
    }

    response = requests.post(url=url, headers=headers, json=params).json()
    #print(response)
    prices = [response["result"]["items"][0]["price"]
              #response["result"]["items"][1]["price"]
              #response["result"]["items"][2]["price"]
              ] 

    if payment == ["75"]:
        payment = 'tinkoff'
    elif payment == ["185"]:
        payment = 'rosbank'


    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'Bybit', 
                       'payment': payment, 
                       'price': prices})

    # Return the DataFrame
    return df




def get_bybit_data_sell(coin, payment):
    url = 'https://api2.bybit.com/fiat/otc/item/online'

    headers = {
        'accept': 'application/json',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36'
    }

    params = {
    "userId": "",
    "tokenId": coin,
    "currencyId": "RUB",
    "payment": payment,
    "side": "0",
    "size": "10",
    "page": "1",
    "authMaker" : True
    }
    response = requests.post(url=url, headers=headers, json=params).json()
    #print(response)
    prices = [response["result"]["items"][0]["price"]
              #response["result"]["items"][1]["price"]
              #response["result"]["items"][2]["price"]
              ] 

    if payment == ["75"]:
        payment = 'tinkoff'
    elif payment == ["185"]:
        payment = 'rosbank'


    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'Bybit', 
                       'payment': payment, 
                       'price': prices})

    # Return the DataFrame
    return df



    #=======================END_OF_BYBIT=======================


    #=======================KUCOIN=======================
'''

def get_kucoin_p2p_rates(region, payment_method, fiat_currency):
    url = "https://api.kucoin.com/v1/offer/active-offers"
    params = {
        "region": region,
        "paymentMethod": payment_method,
        "fiatCurrency": fiat_currency
    }
    response = requests.get(url, params=params)
    
    if response.status_code == 200:
        data = response.json()
        return data["data"]
    else:
        return None

region = "RU"
payment_method = "TINKOFF"
fiat_currency = "usdt"
rates = get_kucoin_p2p_rates(region, payment_method, fiat_currency)

if rates:
    for rate in rates:
        pass
        #print(f"User: {rate['userId']} | Price: {rate['price']} | Amount: {rate['amount']} | Currency: {rate['currency']}")
else:
    print("No data found.")'''

    #=======================END_OF_KUCOIN=======================


    #=======================GARANTEX=======================
#Garantex BUY
def get_garantex_data_sell(coin):
    coin = coin.lower()
    url = 'https://garantex.io/api/v2/depth?market={coin}rub'.format(coin=coin)

    response = requests.get(url=url).json()

    prices = [response['bids'][0]['price'], 
              response['bids'][1]['price'], 
              response['bids'][2]['price']]
    
    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'garantex', 
                       'payment': 'garantex', 
                       'price': prices})

    # Return the DataFrame
    return df



#Garantex SELL
def get_garantex_data_buy(coin):
    coin = coin.lower()
    url = 'https://garantex.io/api/v2/depth?market={coin}rub'.format(coin=coin)

    response = requests.get(url=url).json()

    prices = [response['asks'][0]['price'], 
              response['asks'][1]['price'], 
              response['asks'][2]['price']]
    
    # Create a DataFrame with the desired output format
    df = pd.DataFrame({'currency': 'garantex', 
                       'payment': 'garantex', 
                       'price': prices})

    # Return the DataFrame
    return df
    #=======================END_OF_GARANTEX=======================

# ============================================================================
                            #personal
def get_all(coin):

    binance_pm = [
        ["TinkoffNew"],
        ['RosBankNew']
    ]

    # bybit payment method
    bybit_pm = [
        ["75"], # TINKOFF
        ['185'] # ROSBANK
    ]
    # HUOBI
    #Payment Methods: Tinkoff - 28, Sberbank - 29
    #Coins:  ETH - 3, BTC - 1, USDT - 2

    coins = [3, 1, 2] 
    huobi_pm = [28, 29]




    huobi_coin = ''
    if coin == 'BTC':
        huobi_coin = 1
    elif coin == 'USDT':
        huobi_coin = 2
    elif coin == 'ETH':
        huobi_coin = 3   


    while True:
        # Garantex
        garantex_data_garantex_buy = get_garantex_data_buy(coin) #вывод в виде:       currency payment price 1st 2nd 3th position
        garantex_data_garantex_sell = get_garantex_data_sell(coin)

        # ROSBANK buy
        binance_data_rosbank_buy = get_binance_data_buy(coin, binance_pm[0]) #вывод в виде:       currency payment price  1st 2nd 3th position
        #bybit_data_rosbank_buy = get_bybit_data_buy(coin, bybit_pm[0]) #вывод в виде:       currency payment price  1st 2nd 3th position
        #kucoin_data_rosbank_buy = get_kucoin_data_buy(coin, payment_method) #вывод в виде:       currency payment price  1st 2nd 3th position
        huobi_data_rosbank_buy = get_huobi_data_buy(huobi_coin, huobi_pm[0]) #вывод в виде:       currency payment price  1st 2nd 3th position

        # ROSBANK Sell
        binance_data_rosbank_sell = get_binance_data_sell(coin, binance_pm[0]) #вывод в виде:       currency payment price  1st 2nd 3th position
        bybit_data_rosbank_sell = get_bybit_data_sell(coin, bybit_pm[0]) #вывод в виде:       currency payment price  1st 2nd 3th position
        #kucoin_data_rosbank_sell = get_kucoin_data_sell(coin, payment_method) #вывод в виде:       currency payment price  1st 2nd 3th position
        huobi_data_rosbank_sell = get_huobi_data_sell(huobi_coin, huobi_pm[0]) #вывод в виде:       currency payment price  1st 2nd 3th position


        # TINKOFF Buy
        binance_data_tinkoff_buy = get_binance_data_buy(coin, binance_pm[1]) #вывод в виде:       currency payment price  1st 2nd 3th position
        #bybit_data_tinkoff_buy = get_bybit_data_buy(coin, bybit_pm[1]) #вывод в виде:       currency payment price  1st 2nd 3th position
        #kucoin_data_tinkoff_buy = get_kucoin_data_buy(coin, payment_method) #вывод в виде:       currency payment price  1st 2nd 3th position
        huobi_data_tinkoff_buy = get_huobi_data_buy(huobi_coin, huobi_pm[1]) #вывод в виде:       currency payment price  1st 2nd 3th position

        # TINKOFF Sell
        binance_data_tinkoff_sell = get_binance_data_sell(coin, binance_pm[1]) #вывод в виде:       currency payment price  1st 2nd 3th position
        bybit_data_tinkoff_sell = get_bybit_data_sell(coin, bybit_pm[1]) #вывод в виде:       currency payment price  1st 2nd 3th position
        #kucoin_data_tinkoff_sell = get_kucoin_data_sell(coin, payment_method) #вывод в виде:       currency payment price  1st 2nd 3th position
        huobi_data_tinkoff_sell = get_huobi_data_sell(huobi_coin, huobi_pm[1]) #вывод в виде:       currency payment price  1st 2nd 3th position


        all_data_buy = concatenate_data(
            garantex_data_garantex_buy,
            binance_data_rosbank_buy,
            #bybit_data_rosbank_buy,
            #kucoin_data_rosbank_buy,
            huobi_data_rosbank_buy,
            binance_data_tinkoff_buy,
            #bybit_data_tinkoff_buy,
            #kucoin_data_tinkoff_buy,
            huobi_data_tinkoff_buy       
        )
        all_data_sell = concatenate_data(        # функция concatinat_data одна и таже тк она просто обеденяет несколько df в один большой df
            garantex_data_garantex_sell,
            binance_data_rosbank_sell,
            #bybit_data_rosbank_sell,
            #kucoin_data_rosbank_sell,
            huobi_data_rosbank_sell,
            binance_data_tinkoff_sell,
            #bybit_data_tinkoff_sell,
            #kucoin_data_tinkoff_sell,
            huobi_data_tinkoff_sell,      
        )
        


        merged_data = merge_all_data(all_data_buy, all_data_sell)#.head(3)
        





        #print(merged_data)
        dataframe = spret(merged_data)
        return dataframe
    

# ============================================================================
#                                   SPOT
# ============================================================================

def binance(cryptos):
    pairs = []
    prices = []
    for crypto in cryptos:
        url = "https://api.binance.com/api/v3/ticker/price"
        params = {"symbol": [f"{crypto}USDT"]}
        response = requests.get(url, params=params).json()
        #print(response)

        pairs.append(response["symbol"])
        prices.append(response["price"])
    return prices


def huobi(cryptos):
    
    # Define the API endpoint
    endpoint = 'https://api.huobi.pro/market/tickers'

    # Construct the list of symbols to query
    symbols = ','.join([crypto.lower()+'usdt' for crypto in cryptos])

    # Make the API request
    response = requests.get(endpoint, params={'symbols': symbols})

    # Check the response status code
    if response.status_code == 200:
        # Extract the price data from the response JSON
        data = response.json()['data']

        # Create a list of spot prices for each requested cryptocurrency
        spot_prices = []
        for crypto in cryptos:
            symbol = crypto.lower() + 'usdt'
            for ticker in data:
                if ticker['symbol'] == symbol:
                    spot_prices.append(float(ticker['close']))
                    break
            else:
                spot_prices.append(None)

        return spot_prices

    else:
        # Raise an exception if the request was unsuccessful
        raise Exception(f'Request failed with status code {response.status_code}')



def kucoin(cryptos):
    prices = []

    for symbol in cryptos:
        url = f"https://api.kucoin.com/api/v1/market/orderbook/level1?symbol={symbol}-USDT"
        response = requests.get(url)
        
        data = response.json()
        #print(data)
        if data['code'] == '200000':
            last_price = data['data']['price']
            prices.append(last_price)
        else:
            prices.append(0)


        
    return prices




def bybit(cryptos):
    api_key = 'Vjd82sZDJacRuxiHcz'
    api_secret = 'lqgKUiGuRNTibt6ME3lW7e7Buw3dKfaMqJQE'

    prices = []

    for s in cryptos:
        # Define the endpoint and query parameters
        endpoint = '/spot/v3/public/quote/ticker/24hr'
        params = f'symbol={s}USDT'

        # Construct the message to sign
        timestamp = int(time.time() * 1000)
        message = f'{endpoint}{timestamp}{params}'

        # Sign the message using the API secret
        signature = hmac.new(api_secret.encode(), message.encode(), hashlib.sha256).hexdigest()

        # Make the API request with the signature in the headers
        url = f'https://api.bybit.com{endpoint}?{params}'
        headers = {
            'api-key': api_key,
            'api-signature': signature,
            'api-request-date': str(timestamp)
        }
        response = requests.get(url, headers=headers)

        if response.status_code == 200:
            data = response.json()['result']['lp']
            prices.append(data)
        else:
            #print('Error:', response.status_code, response.reason)
            prices.append(0)

    return prices
    

# ============================================================================
#                                   SPOT (special for P2P_PRO)
# ============================================================================    

def binance_pro(crypto1, crypto2):
    commision = 0.001
    symbol=crypto1+crypto2
    url = "https://api.binance.com/api/v3/ticker/price"
    params = {"symbol": [f"{crypto1+crypto2}"]}
    response = requests.get(url, params=params).json()
    #print(response)
    price = response["price"]
    return symbol, price, commision


def huobi_pro(crypto1, crypto2):
    symbol = crypto1 + crypto2
    commision = 0.002
    # Define the API endpoint
    endpoint = 'https://api.huobi.pro/market/tickers'

    # Construct the list of symbols to query
    symbols = ','.join([crypto1.lower() + crypto2.lower()])

    # Make the API request
    response = requests.get(endpoint, params={'symbols': symbols})

    # Check the response status code
    if response.status_code == 200:
        # Extract the price data from the response JSON
        data = response.json()['data']

        # Create a list of spot prices for each requested cryptocurrency
        spot_prices = []
        
        symbol = crypto1.lower() + crypto2.lower()
        for ticker in data:
            if ticker['symbol'] == symbol:
                spot_prices.append(float(ticker['close']))
                break
        else:
            spot_prices.append(None)

        return symbol, spot_prices, commision

    else:
        # Raise an exception if the request was unsuccessful
        raise Exception(f'Request failed with status code {response.status_code}')





def bybit_pro(crypto1, crypto2):
    commision = 0.0002    
    symbol=crypto1+crypto2
    api_key = 'Vjd82sZDJacRuxiHcz'
    api_secret = 'lqgKUiGuRNTibt6ME3lW7e7Buw3dKfaMqJQE'

    prices = []

    # Define the endpoint and query parameters
    endpoint = '/spot/v3/public/quote/ticker/24hr'
    params = f'symbol={crypto1+crypto2}'

    # Construct the message to sign
    timestamp = int(time.time() * 1000)
    message = f'{endpoint}{timestamp}{params}'

    # Sign the message using the API secret
    signature = hmac.new(api_secret.encode(), message.encode(), hashlib.sha256).hexdigest()

        # Make the API request with the signature in the headers
    url = f'https://api.bybit.com{endpoint}?{params}'
    headers = {
        'api-key': api_key,
        'api-signature': signature,
        'api-request-date': str(timestamp)
    }
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()['result']['lp']
        prices.append(data)
    else:
        #print('Error:', response.status_code, response.reason)
        prices.append(0)

    return symbol, prices, commision




