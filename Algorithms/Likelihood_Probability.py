import matplotlib.pyplot as plt
import numpy as npy

def normaldistribution(x,m,s):
    y = (1/(s*npy.sqrt(2*npy.pi)))*npy.exp(-0.5*(((x-m)/s)**2))
    return y

t = npy.arange(-10.0, 10.0, 0.1)

sigma = 3.5
mu = 0.0
y = normaldistribution(t,mu,sigma)
plt.plot(t, y, 'black')

p_range = npy.where((t >= -2.5) & (t <= 2.5))
t_p = t[p_range]
y_p = y[p_range]

plt.plot(t_p, y_p, 'black')
plt.fill_between(t_p, y_p, color='green')

xm = -3.0
ym = normaldistribution(xm,mu,sigma)
plt.plot(xm, ym, 'bo')

plt.text(-6.5, ym, 'likelihood', color = 'blue')
plt.annotate('probability', color='green', xy=(0,0.03), xytext=(3.5,0.01), arrowprops=dict(color='green', arrowstyle="-"))

#plt.savefig('C:\GitHub\RegressionModels\Images\Likelihood_Probability.jpg', format='jpg', dpi=200)
plt.show()
