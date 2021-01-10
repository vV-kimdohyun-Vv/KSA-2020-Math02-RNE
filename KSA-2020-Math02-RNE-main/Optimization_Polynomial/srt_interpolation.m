xdata = [0 1.06 2.54 4.24 5.28 6.64 8.03 8.86 9.72 10.78 12.11 13.44 14.99 17.28]';
ydata = [0 0.01 0.04 0.33 0.72 1.37 2.33 3.1 3.91 4.7 5.41 5.89 6.22 6.32]';
T = table(xdata, ydata);
p = polyfit(T.xdata, T.ydata, 10)
f = polyval(p,xdata);
%plot(xdata,f)

% 시도하던 중 손절한 파일

