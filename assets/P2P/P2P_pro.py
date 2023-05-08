from functions import *

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


    df = []
    to_buy = []
    currency_to_buy = []
    payment_to_buy = []
    exchange_to = []
    cuurency_to_exchange = []
    currency_to_sell = []
    payment_to_sell = []
    spret = []

    tb = 'USDT'
    p2p_currency = usdt_p2p['currency_buy'][0]
    p2p_payment = usdt_p2p['payment_buy'][0]
    p2p_price = usdt_p2p['price_buy'][0]

    symbol, bnb, commision_binance,    = binance_pro('ETH', 'USDT')
    currency1 = 'binance'
    symbol, huobi, commision_huobi,  = huobi_pro('ETH', 'USDT')
    currency2 = 'huobi'
    symbol, bybit, commision_bybit, = bybit_pro('ETH', 'USDT')
    currency3 = 'bybit'

    currencyts = eth_p2p['currency_sell'][0]
    paymentts = eth_p2p['payment_sell'][0]

    v1 = float(p2p_price) / (float(p2p_price)/float(binance_pro('ETH', 'USDT')[1])*float(eth_p2p['price_sell'][0])*float((1-commision_binance)))
    v2 = float(p2p_price) / (float(p2p_price)/float(huobi_pro('ETH', 'USDT')[1][0])*float(eth_p2p['price_sell'][0])*float((1-commision_huobi)))
    v3 = float(p2p_price) / (float(p2p_price)/float(bybit_pro('ETH', 'USDT')[1][0])*float(eth_p2p['price_sell'][0])*float((1-commision_bybit)))
    v4 = usdt_p2p['spret'][0]
    all = [v1, v2, v3, v4]
    max_number = max(all)
    index_of_best = all.index(max_number)

    if index_of_best == 0:
        spretc = v1
        currency_to_exchange_V = 'binance'
        to_sell = 'ETH'
    if index_of_best == 1:
        spretc = v2
        currency_to_exchange_V = 'huobi'
        to_sell = 'ETH'
    if index_of_best == 2:
        spretc = v3
        currency_to_exchange_V = 'bybit'
        to_sell = 'ETH'
    if index_of_best == 3:
        spretc = v4
        currency_to_exchange_V = 'no need'
        to_sell = 'USDT'
        currencyts = usdt_p2p['currency_sell'][0]
        paymentts = usdt_p2p['payment_sell'][0]

    to_buy.append(tb)
    currency_to_buy.append(p2p_currency)
    payment_to_buy.append(p2p_payment)
    exchange_to.append(to_sell)
    cuurency_to_exchange.append(currency_to_exchange_V)
    currency_to_sell.append(currencyts)
    payment_to_sell.append(paymentts)
    spret.append(spretc)


    tb = 'USDT'
    p2p_currency = usdt_p2p['currency_buy'][0]
    p2p_payment = usdt_p2p['payment_buy'][0]
    p2p_price = usdt_p2p['price_buy'][0]

    symbol, bnb, commision_binance,    = binance_pro('BTC', 'USDT')
    currency1 = 'binance'
    symbol, huobi, commision_huobi,  = huobi_pro('BTC', 'USDT')
    currency2 = 'huobi'
    symbol, bybit, commision_bybit, = bybit_pro('BTC', 'USDT')
    currency3 = 'bybit'

    currencyts = btc_p2p['currency_sell'][0]
    paymentts = btc_p2p['payment_sell'][0]

    v1 = float(p2p_price) / (float(p2p_price)/float(binance_pro('BTC', 'USDT')[1])*float(btc_p2p['price_sell'][0])*float((1-commision_binance)))
    v2 = float(p2p_price) / (float(p2p_price)/float(huobi_pro('BTC', 'USDT')[1][0])*float(btc_p2p['price_sell'][0])*float((1-commision_huobi)))
    v3 = float(p2p_price) / (float(p2p_price)/float(bybit_pro('BTC', 'USDT')[1][0])*float(btc_p2p['price_sell'][0])*float((1-commision_bybit)))
    v4 = usdt_p2p['spret'][0]
    all = [v1, v2, v3, v4]
    max_number = max(all)
    index_of_best = all.index(max_number)

    if index_of_best == 0:
        spretc = v1
        currency_to_exchange_V = 'binance'
        to_sell = 'BTC'
    if index_of_best == 1:
        spretc = v2
        currency_to_exchange_V = 'huobi'
        to_sell = 'BTC'
    if index_of_best == 2:
        spretc = v3
        currency_to_exchange_V = 'bybit'
        to_sell = 'BTC'
    if index_of_best == 3:
        spretc = v4
        currency_to_exchange_V = 'no need'
        to_sell = 'USDT'
        currencyts = usdt_p2p['currency_sell'][0]
        paymentts = usdt_p2p['payment_sell'][0]

    to_buy.append(tb)
    currency_to_buy.append(p2p_currency)
    payment_to_buy.append(p2p_payment)
    exchange_to.append(to_sell)
    cuurency_to_exchange.append(currency_to_exchange_V)
    currency_to_sell.append(currencyts)
    payment_to_sell.append(paymentts)
    spret.append(spretc)

    tb = 'ETH'
    p2p_currency = eth_p2p['currency_buy'][0]
    p2p_payment = eth_p2p['payment_buy'][0]
    p2p_price = eth_p2p['price_buy'][0]

    symbol, bnb, commision_binance,    = binance_pro('BTC', 'USDT')
    currency1 = 'binance'
    symbol, huobi, commision_huobi,  = huobi_pro('BTC', 'USDT')
    currency2 = 'huobi'
    symbol, bybit, commision_bybit, = bybit_pro('BTC', 'USDT')
    currency3 = 'bybit'

    currencyts = btc_p2p['currency_sell'][0]
    paymentts = btc_p2p['payment_sell'][0]
    #print(currencyts)


    v1 = float(p2p_price) / (float(p2p_price)/float(binance_pro('ETH', 'BTC')[1])*float(btc_p2p['price_sell'][0])*float((1-commision_binance)))
    v2 = float(p2p_price) / (float(p2p_price)/float(huobi_pro('ETH', 'BTC')[1][0])*float(btc_p2p['price_sell'][0])*float((1-commision_huobi)))
    v3 = float(p2p_price) / (float(p2p_price)/float(bybit_pro('ETH', 'BTC')[1][0])*float(btc_p2p['price_sell'][0])*float((1-commision_bybit)))
    v4 = eth_p2p['spret'][0]
    all = [v1, v2, v3, v4]
    max_number = max(all)
    index_of_best = all.index(max_number)

    if index_of_best == 0:
        spretc = v1
        currency_to_exchange_V = 'binance'
        to_sell = 'BTC'
    if index_of_best == 1:
        spretc = v2
        currency_to_exchange_V = 'huobi'
        to_sell = 'BTC'
    if index_of_best == 2:
        spretc = v3
        currency_to_exchange_V = 'bybit'
        to_sell = 'BTC'
    if index_of_best == 3:
        spretc = v4
        currency_to_exchange_V = 'no need'
        to_sell = 'ETH'
        currencyts = eth_p2p['currency_sell'][0]
        paymentts = eth_p2p['payment_sell'][0]

    to_buy.append(tb)
    currency_to_buy.append(p2p_currency)
    payment_to_buy.append(p2p_payment)
    exchange_to.append(to_sell)
    cuurency_to_exchange.append(currency_to_exchange_V)
    currency_to_sell.append(currencyts)
    payment_to_sell.append(paymentts)
    spret.append(spretc)


    tb = 'BTC'
    p2p_currency = btc_p2p['currency_buy'][0]
    p2p_payment = btc_p2p['payment_buy'][0]
    p2p_price = btc_p2p['price_buy'][0]

    symbol, bnb, commision_binance,    = binance_pro('ETH', 'USDT')
    currency1 = 'binance'
    symbol, huobi, commision_huobi,  = huobi_pro('ETH', 'USDT')
    currency2 = 'huobi'
    symbol, bybit, commision_bybit, = bybit_pro('ETH', 'USDT')
    currency3 = 'bybit'

    currencyts = eth_p2p['currency_sell'][0]
    paymentts = eth_p2p['payment_sell'][0]
    #print(currencyts)

    v1 = float(p2p_price) / (float(p2p_price)/float(binance_pro('ETH', 'BTC')[1])*float(eth_p2p['price_sell'][0])*float((1-commision_binance)))
    v2 = float(p2p_price) / (float(p2p_price)/float(huobi_pro('ETH', 'BTC')[1][0])*float(eth_p2p['price_sell'][0])*float((1-commision_huobi)))
    v3 = float(p2p_price) / (float(p2p_price)/float(bybit_pro('ETH', 'BTC')[1][0])*float(eth_p2p['price_sell'][0])*float((1-commision_bybit)))
    v4 = btc_p2p['spret'][0]
    all = [v1, v2, v3, v4]
    max_number = max(all)
    index_of_best = all.index(max_number)

    if index_of_best == 0:
        spretc = v1
        currency_to_exchange_V = 'binance'
        to_sell = 'BTC'
    if index_of_best == 1:
        spretc = v2
        currency_to_exchange_V = 'huobi'
        to_sell = 'BTC'
    if index_of_best == 2:
        spretc = v3
        currency_to_exchange_V = 'bybit'
        to_sell = 'BTC'
    if index_of_best == 3:
        spretc = v4
        currency_to_exchange_V = 'no need'
        to_sell = 'BTC'
        currencyts = btc_p2p['currency_sell'][0]
        paymentts = btc_p2p['payment_sell'][0]

    to_buy.append(tb)
    currency_to_buy.append(p2p_currency)
    payment_to_buy.append(p2p_payment)
    exchange_to.append(to_sell)
    cuurency_to_exchange.append(currency_to_exchange_V)
    currency_to_sell.append(currencyts)
    payment_to_sell.append(paymentts)
    spret.append(spretc)




    tb = 'ETH'
    p2p_currency = eth_p2p['currency_buy'][0]
    p2p_payment = eth_p2p['payment_buy'][0]
    p2p_price = eth_p2p['price_buy'][0]

    symbol, bnb, commision_binance,    = binance_pro('ETH', 'USDT')
    currency1 = 'binance'
    symbol, huobi, commision_huobi,  = huobi_pro('ETH', 'USDT')
    currency2 = 'huobi'
    symbol, bybit, commision_bybit, = bybit_pro('ETH', 'USDT')
    currency3 = 'bybit'

    currencyts = usdt_p2p['currency_sell'][0]
    paymentts = usdt_p2p['payment_sell'][0]
    #print(currencyts)

    v1 = float(p2p_price) / (float(p2p_price)/(1/float(binance_pro('ETH', 'USDT')[1]))*float(usdt_p2p['price_sell'][0])*float((1-commision_binance)))
    v2 = float(p2p_price) /(float(p2p_price) /(1/float(huobi_pro('ETH', 'USDT')[1][0]))*float(usdt_p2p['price_sell'][0])*float((1-commision_huobi)))
    v3 = float(p2p_price) / (float(p2p_price)/(1/float(bybit_pro('ETH', 'USDT')[1][0]))*float(usdt_p2p['price_sell'][0])*float((1-commision_bybit)))
    v4 = eth_p2p['spret'][0]
    all = [v1, v2, v3, v4]
    max_number = max(all)
    index_of_best = all.index(max_number)

    if index_of_best == 0:
        spretc = v1
        currency_to_exchange_V = 'binance'
        to_sell = 'USDT'
    if index_of_best == 1:
        spretc = v2
        currency_to_exchange_V = 'huobi'
        to_sell = 'USDT'
    if index_of_best == 2:
        spretc = v3
        currency_to_exchange_V = 'bybit'
        to_sell = 'USDT'
    if index_of_best == 3:
        spretc = v4
        currency_to_exchange_V = 'no need'
        to_sell = 'ETH'
        currencyts = eth_p2p['currency_sell'][0]
        paymentts = eth_p2p['payment_sell'][0]

    to_buy.append(tb)
    currency_to_buy.append(p2p_currency)
    payment_to_buy.append(p2p_payment)
    exchange_to.append(to_sell)
    cuurency_to_exchange.append(currency_to_exchange_V)
    currency_to_sell.append(currencyts)
    payment_to_sell.append(paymentts)
    spret.append(spretc)








    tb = 'BTC'.upper()
    p2p_currency = btc_p2p['currency_buy'][0]
    p2p_payment = btc_p2p['payment_buy'][0]
    p2p_price = btc_p2p['price_buy'][0]

    symbol, bnb, commision_binance,    = binance_pro('BTC', 'USDT')
    currency1 = 'binance'
    symbol, huobi, commision_huobi,  = huobi_pro('BTC', 'USDT')
    currency2 = 'huobi'
    symbol, bybit, commision_bybit, = bybit_pro('BTC', 'USDT')
    currency3 = 'bybit'

    currencyts = btc_p2p['currency_sell'][0]
    paymentts = btc_p2p['payment_sell'][0]

    v1 = float(p2p_price) / (float(p2p_price)/(1 /float(binance_pro('BTC', 'USDT')[1]))*float(usdt_p2p['price_sell'][0])*float((1-commision_binance)))
    v2 = float(p2p_price) /  (float(p2p_price)/(1/float(huobi_pro('BTC', 'USDT')[1][0]))*float(usdt_p2p['price_sell'][0])*float((1-commision_huobi)))
    v3 = float(p2p_price) / (float(p2p_price)/(1/ float(bybit_pro('BTC', 'USDT')[1][0]))*float(usdt_p2p['price_sell'][0])*float((1-commision_bybit)))
    v4 = btc_p2p['spret'][0]
    all = [v1, v2, v3, v4]
    max_number = max(all)
    index_of_best = all.index(max_number)

    if index_of_best == 0:
        spretc = v1
        currency_to_exchange_V = 'binance'
        to_sell = 'USDT'
    if index_of_best == 1:
        spretc = v2
        currency_to_exchange_V = 'huobi'
        to_sell = 'USDT'
    if index_of_best == 2:
        spretc = v3
        currency_to_exchange_V = 'bybit'
        to_sell = 'USDT'
    if index_of_best == 3:
        spretc = v4
        currency_to_exchange_V = 'no need'
        to_sell = 'BTC'
        currencyts = btc_p2p['currency_sell'][0]
        paymentts = btc_p2p['payment_sell'][0]

    #print(123123)
    to_buy.append(tb)
    currency_to_buy.append(p2p_currency)
    payment_to_buy.append(p2p_payment)
    exchange_to.append(to_sell)
    cuurency_to_exchange.append(currency_to_exchange_V)
    currency_to_sell.append(currencyts)
    payment_to_sell.append(paymentts)
    spret.append(spretc)




    df = pd.DataFrame({
        'To Buy': to_buy,
        'Currency to Buy': currency_to_buy,
        'Payment to Buy': payment_to_buy,
        'Exchange To': exchange_to,
        'Currency to Exchange': cuurency_to_exchange,
        'Currency to Sell': currency_to_sell,
        'Payment to Sell': payment_to_sell,
        'spret': spret
    })

    #print(df)
    return df












