from P2P_pro import *
import requests
import pandas as pd
import time
import os

#================================== config===================================
def get_df():
    usdt_p2p = get_all('USDT')
    eth_p2p  = get_all('ETH')
    btc_p2p  = get_all('BTC')


    binance_pm = [ 
        ["TinkoffNew"],
        ['RosBankNew']
    ]


    bybit_pm = [
        ["75"], 
        ['185'] 
    ]


    coins = [3, 1, 2] 
    huobi_pm = [28, 29]


#================================== STRATEGY===================================
variants = [  
    'BTC/USDT',
    'ETH/USDT',
    'USDT/BTC',
    'USDT/ETH',    
    'BTC/ETH',
    #'ETH/ETH',
    #'BTC/BTC',
    #'USDT/USDT'
]

ex= [
    'BTC/ETH',
    'USDT/BTC',
    'USDT/ETH'
]


def spec_bin(crypto1, crypto2):
    balance = 100000 #RUB
    # commission
    binance_com = 1-0.001
    huobi_com = 1-0.002
    bybit_com = 1-0.0002
    garantex_com = 1-0.002
    commision_p2p_b = 1
    commision_p2p_s = 1
    # -----


    cr1_p2p_a = get_all(crypto1)
    cr2_p2p_a = get_all(crypto2)
    # -----
    if crypto1 != crypto2:  
        cr1_p2p = float(cr1_p2p_a['price_buy'][0])
        cr2_p2p = float(cr2_p2p_a['price_sell'][0])

        #carcas = (  ((balance/cr1_p2p*commision_p2p) * currency(crypto1, crypto2))*currency_com * cr2_p2p ) / balance*commision_p2p
        if cr1_p2p_a['currency_buy'][0] == 'garantex':
            commision_p2p_b = garantex_com

        if cr2_p2p_a['currency_sell'][0] == 'garantex':
            commision_p2p_b = garantex_com


        v1 = (  ((balance/cr1_p2p*commision_p2p_b) / float(binance_pro(crypto2, crypto1)[1]))*binance_com * cr2_p2p ) / balance*commision_p2p_s-1
        v2 = (  ((balance/cr1_p2p*commision_p2p_b) / float(bybit_pro(crypto2, crypto1)[1][0]))*bybit_com * cr2_p2p ) / balance*commision_p2p_s-1
        v3 = (  ((balance/cr1_p2p*commision_p2p_b) / float(huobi_pro(crypto2, crypto1)[1][0]))*huobi_com * cr2_p2p ) / balance*commision_p2p_s-1

        to_buy = [crypto1,crypto1,crypto1]
        to_sell= [crypto2,crypto2,crypto2]
        sprets = [v1, v2, v3]
        to_exchange = ['binance', 'bybit', 'huobi']
        price_to_buy = [cr1_p2p,cr1_p2p,cr1_p2p]
        price_to_sell = [cr2_p2p,cr2_p2p,cr2_p2p]

        df = pd.DataFrame({
            'To Buy': to_buy,
            'To Sell': to_sell,
            'Sprets': sprets,
            'To Exchange': to_exchange,
            'Price to Buy': price_to_buy,
            'Price to Sell': price_to_sell
        })
        return df

def p2ppro(pair, ex):
    par = pair
    balance = 100000 #RUB
    # commission
    binance_com = 1-0.001
    huobi_com = 1-0.002
    bybit_com = 1-0.0002
    garantex_com = float(1-0.0025)
    commision_p2p_b = 1
    commision_p2p_s = 1
    # -----

    # split recived parameters
    pair = pair.split('/')
    crypto1, crypto2 = pair[0], pair[1]
    cr1_p2p_a = get_all(crypto1)
    cr2_p2p_a = get_all(crypto2)
    # -----
    if crypto1 != crypto2 and par not in ex: 
        cr1_p2p = float(cr1_p2p_a['price_buy'][0])
        cr2_p2p = float(cr2_p2p_a['price_sell'][0])

        #carcas = (  ((balance/cr1_p2p*commision_p2p) * currency(crypto1, crypto2))*currency_com * cr2_p2p ) / balance*commision_p2p
        if cr1_p2p_a['currency_buy'][0] == 'garantex':
            commision_p2p_b = garantex_com

        if cr2_p2p_a['currency_sell'][0] == 'garantex':
            commision_p2p_s = garantex_com

        #print(cr1_p2p_a)
        #print(cr2_p2p_a)
        #print(f"((({balance}/{cr1_p2p}*{commision_p2p_b}) * {binance_pro(crypto1, crypto2)[1]})*{binance_com} * {cr2_p2p} )/{balance}*{commision_p2p_s}")
        v1 = (  ((balance/cr1_p2p*commision_p2p_b) * float(binance_pro(crypto1, crypto2)[1]))*binance_com * cr2_p2p ) / balance*commision_p2p_s-1
        v2 = (  ((balance/cr1_p2p*commision_p2p_b) * float(bybit_pro(crypto1, crypto2)[1][0]))*bybit_com * cr2_p2p ) / balance*commision_p2p_s-1
        v3 = (  ((balance/cr1_p2p*commision_p2p_b) * float(huobi_pro(crypto1, crypto2)[1][0]))*huobi_com * cr2_p2p ) / balance*commision_p2p_s-1

        to_buy = [crypto1,crypto1,crypto1]
        to_sell= [crypto2,crypto2,crypto2]
        sprets = [v1, v2, v3]
        to_exchange = ['binance', 'bybit', 'huobi']
        price_to_buy = [cr1_p2p,cr1_p2p,cr1_p2p]
        price_to_sell = [cr2_p2p,cr2_p2p,cr2_p2p]

        df = pd.DataFrame({
            'To Buy': to_buy,
            'To Sell': to_sell,
            'Sprets': sprets,
            'To Exchange': to_exchange,
             'Price to Buy': price_to_buy,
            'Price to Sell': price_to_sell
        })
        return df


    elif crypto1 != crypto2 and par in ex:
        return spec_bin(crypto1, crypto2)

    else:
        return cr1_p2p_a['spret'][0]

def append_dataframes(df1, df2):
    if isinstance(df2, pd.Series):
        df2 = pd.DataFrame(df2).T
    elif isinstance(df2, np.ndarray):
        df2 = pd.DataFrame(df2).T
 
    return pd.concat([df1, df2], ignore_index=True)

def save_to_csv(df):
    filename = f"P2P_pro.csv"
    df.to_csv(filename, index=False)
    print(f"Dataframe saved as {filename}") 

while True:
    f = 0
    dataframe = []
    for pair in variants:
        print('---------------------------------------',pair,'---------------------------------------')   
        if f == 0:
            dataframe = p2ppro(pair, ex)
            f+=1
        else:
            dataframe = append_dataframes(dataframe, p2ppro(pair, ex))
    dataframe = dataframe.sort_values(by='Sprets', ascending=False)
    
    if os.name == 'nt':
        os.system('cls')
    else:
        os.system('clear')

    save_to_csv(dataframe)
    print(dataframe)