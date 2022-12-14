
# -*- coding: utf-8 -*-
"""
Created on Wed Sep 29 16:24:20 2021

@author: irene1017a
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as solver
from functools import reduce
data = pd.read_csv(r'C:/Users/irene1017a/OneDrive/Project/基金/Quarter performance/Q4_1001.csv',index_col=0, parse_dates=True)
data.columns

data.isnull().sum()
     

# 共變異數矩陣
cov_matrix = data.pct_change().apply(lambda x: np.log(1+x)).cov()
cov_matrix

# 平均報酬率Y: 年 M: 月 Q: 季 w: 周 d 日 H: 小時 min: 分鐘 s: 秒
expected_return =data.resample('d').last()[:-1].pct_change().mean()
expected_return

# 平均標準差(Day-1,Week-7,month-30,quarter=90) > 每日皆納入計算
standard_dev = data.pct_change().apply(lambda x: np.log(1+x)).std().apply(lambda x: x*np.sqrt(90))


# 整理成表格
return_dev_matrix = pd.concat([expected_return, standard_dev], axis = 1)
return_dev_matrix.columns = ['Exp Returns', 'Standard Dev.']
return_dev_matrix

port_ret = []
port_dev = []
port_weights = []
assets_nums = 58
port_nums = 10000

for port in range(port_nums):
    weights = np.random.random(assets_nums)
    weights = weights/np.sum(weights)
    port_weights.append(weights)
    returns = np.dot(weights, expected_return)
    port_ret.append(returns)
    var = cov_matrix.mul(weights, axis=0).mul(weights, axis=1).sum().sum()
    sd = np.sqrt(var)
    ann_sd = sd*np.sqrt(90)
    port_dev.append(ann_sd)
    
data1 = {'Returns': port_ret, 'Standard Dev.': port_dev}

portfolios = pd.DataFrame(data1)
portfolios.head()
portfolios

for counter, symbol in enumerate(data.columns.tolist()):
   portfolios[symbol+' weight'] = [w[counter] for w in port_weights]
    

#計算效率前緣
#這邊就要用Python找出最左上角的點，稍微寫一下演算法：
#將標準差(x軸)切成1000等份
#針對每一個小等份找出最高報酬率的點
#如果這個點的報酬率高於前一個等份的最高報酬率，就將這個點加入效率前緣組合
# 取效率前緣
std = []
ret = [portfolios[portfolios['Standard Dev.'] == portfolios['Standard Dev.'].min()]['Returns'].values[0]]
portfolios.columns
eff_front_set = pd.DataFrame(columns=portfolios.columns)
for i in range(20,1000,1):
    df = portfolios[(portfolios['Standard Dev.'] >= i/10000) & (portfolios['Standard Dev.'] <= (i+15)/10000)]
    try:
        # 上側
        max_ret = df[df['Returns'] == df['Returns'].max()]['Returns'].values[0]
        if max_ret >= max(ret):
            std.append(df[df['Returns'] == df['Returns'].max()]['Standard Dev.'].values[0])
            ret.append(df[df['Returns'] == df['Returns'].max()]['Returns'].values[0])
            eff_front_set = eff_front_set.append(df[df['Returns'] == df['Returns'].max()], ignore_index = True)
    except:
        pass

ret.pop(0)
eff_front_std = pd.Series(std)
eff_front_ret = pd.Series(ret)


#MVP
mvp_std = min(eff_front_std)
print('MVP風險為: ' + str(round(mvp_std,4)))


# 找夏普比率最大的投組
max_sharpe = -1
max_sharpe_returns = -1
max_sharpe_std = 0
risk_free = 0.0153/12
for i in range(len(eff_front_set)):
    sharpe = ( eff_front_set.iloc[i,:]['Returns'] - risk_free ) / eff_front_set.iloc[i,:]['Standard Dev.']
    if sharpe > max_sharpe:
        max_sharpe = sharpe
        max_sharpe_std = eff_front_set.iloc[i,:]['Standard Dev.']
        max_sharpe_returns = eff_front_set.iloc[i,:]['Returns']
        max_sharpe_set = (eff_front_set.iloc[i,:][portfolios.columns[2]], eff_front_set.iloc[i,:][portfolios.columns[3]],
                          eff_front_set.iloc[i,:][portfolios.columns[4]], eff_front_set.iloc[i,:][portfolios.columns[5]],
                          eff_front_set.iloc[i,:][portfolios.columns[6]], eff_front_set.iloc[i,:][portfolios.columns[7]],
                          eff_front_set.iloc[i,:][portfolios.columns[8]], eff_front_set.iloc[i,:][portfolios.columns[9]],
                          eff_front_set.iloc[i,:][portfolios.columns[10]], eff_front_set.iloc[i,:][portfolios.columns[11]],
                          eff_front_set.iloc[i,:][portfolios.columns[12]], eff_front_set.iloc[i,:][portfolios.columns[13]],
                          eff_front_set.iloc[i,:][portfolios.columns[14]], eff_front_set.iloc[i,:][portfolios.columns[15]],
                          eff_front_set.iloc[i,:][portfolios.columns[16]], eff_front_set.iloc[i,:][portfolios.columns[17]],
                          eff_front_set.iloc[i,:][portfolios.columns[18]], eff_front_set.iloc[i,:][portfolios.columns[19]],
                          eff_front_set.iloc[i,:][portfolios.columns[20]], eff_front_set.iloc[i,:][portfolios.columns[21]],
                          eff_front_set.iloc[i,:][portfolios.columns[22]], eff_front_set.iloc[i,:][portfolios.columns[23]],
                          eff_front_set.iloc[i,:][portfolios.columns[24]], eff_front_set.iloc[i,:][portfolios.columns[25]],
                          eff_front_set.iloc[i,:][portfolios.columns[26]], eff_front_set.iloc[i,:][portfolios.columns[27]],
                          eff_front_set.iloc[i,:][portfolios.columns[28]], eff_front_set.iloc[i,:][portfolios.columns[29]],
                          eff_front_set.iloc[i,:][portfolios.columns[30]], eff_front_set.iloc[i,:][portfolios.columns[31]],
                          eff_front_set.iloc[i,:][portfolios.columns[32]], eff_front_set.iloc[i,:][portfolios.columns[33]],
                          eff_front_set.iloc[i,:][portfolios.columns[34]], eff_front_set.iloc[i,:][portfolios.columns[35]],
                          eff_front_set.iloc[i,:][portfolios.columns[36]], eff_front_set.iloc[i,:][portfolios.columns[37]],
                          eff_front_set.iloc[i,:][portfolios.columns[38]], eff_front_set.iloc[i,:][portfolios.columns[39]],
                          eff_front_set.iloc[i,:][portfolios.columns[40]], eff_front_set.iloc[i,:][portfolios.columns[41]],
                          eff_front_set.iloc[i,:][portfolios.columns[42]], eff_front_set.iloc[i,:][portfolios.columns[43]],
                          eff_front_set.iloc[i,:][portfolios.columns[44]], eff_front_set.iloc[i,:][portfolios.columns[45]],
                          eff_front_set.iloc[i,:][portfolios.columns[46]], eff_front_set.iloc[i,:][portfolios.columns[47]],
                          eff_front_set.iloc[i,:][portfolios.columns[48]], eff_front_set.iloc[i,:][portfolios.columns[49]],
                          eff_front_set.iloc[i,:][portfolios.columns[50]], eff_front_set.iloc[i,:][portfolios.columns[51]],
                          eff_front_set.iloc[i,:][portfolios.columns[52]], eff_front_set.iloc[i,:][portfolios.columns[53]],
                          eff_front_set.iloc[i,:][portfolios.columns[54]], eff_front_set.iloc[i,:][portfolios.columns[55]],
                          eff_front_set.iloc[i,:][portfolios.columns[56]], eff_front_set.iloc[i,:][portfolios.columns[57]],
                          eff_front_set.iloc[i,:][portfolios.columns[58]])
print("夏普比率最大點的報酬率與標準差 ", "(Returns, Standard Dev.) =", (max_sharpe_returns, max_sharpe_std))
print("夏普比率最大點的投組",portfolios.columns , max_sharpe_set)
portfolios.columns[58]

#視覺化
import matplotlib.pyplot as plt
fig = plt.figure(figsize = (12,6))
ax = fig.add_subplot()
plt.figure(figsize=(20,15))
fig.subplots_adjust(top=0.85)
ax0 = ax.scatter(portfolios['Standard Dev.'], portfolios['Returns'],
                c=(np.array(portfolios['Returns'])-risk_free)/np.array(portfolios['Standard Dev.']),
                marker = 'o',s = 10)

# 無風險資產
ax.scatter(x = 0, y = risk_free, c = 'g', s = 100)
ax.annotate("10-years treasury", (0,risk_free), textcoords="offset points", xytext=(0,10), ha='left', fontsize=10)

# max sharpe set
ax.scatter(x = max_sharpe_std, y = max_sharpe_returns, c = 'orange', s = 200)
ax.annotate("Max Sharpe Ratio", (max_sharpe_std, max_sharpe_returns), textcoords="offset points", xytext=(-10,-5), ha='right', fontsize=10)

# 切線
ax.plot([0,max_sharpe_std],[0.00427, max_sharpe_returns])
# 繪圖設定
ax.grid()
ax.set_xlabel("Resource_Bitcoin_LSTM Standard Dev.", fontsize=10)
ax.set_ylabel("Expected Returns", fontsize=10)

ax.plot(eff_front_std, eff_front_ret, linewidth=1, color='r', marker='o',
         markerfacecolor='r', markersize=3)
#MVP
ax.plot(mvp_std, mvp_ret,'*',color='cyan', markerfacecolor='cyan',  markersize=10)
ax.annotate("MVP", (mvp_std, mvp_ret), textcoords="offset points", xytext=(-30,-10), ha='left', fontsize=10)


#標記
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.set_title('Efficient Frontier', fontsize=22, fontweight='bold')
fig.colorbar(ax0, ax=ax, label = 'Sharpe Ratio')
ax.savefig('Efficient_Frontier.png',dpi=300)





