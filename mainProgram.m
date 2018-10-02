 clear, clc;

minutes = 60;
hours = 3;
dataCollection{minutes*hours,:} = zeros;
result = int16.empty(0,0);
spot = 5; % stasiun puncak; leker, kepolo, tretes, besukbang

for i = 1:hours
    for j = 1:minutes
        fmt = strcat('%d %s %s', repmat('%14d',1,25));
        myfolder = sprintf('091001%02d', i-1);
        myfilename = sprintf('091001%02d.%02d.CDM', i-1, j-1);
        full = fullfile(myfolder, myfilename);
        fp = fopen(full);
        data= textscan(fp,fmt,'HeaderLines',2);
        dataCollection{i,j,:} = data;
        fclose(fp);
        result = vertcat(result, dataCollection{i,j,1}{1,spot});
    end
end


initData = result;

%initData = vertcat(dataCollection{1, 1}{1, 4},dataCollection{2, 1}{1, 4});

n = length(initData);
tise = 1:n;
nshift = 1;
windowsLength = 512;
count =0;
parityData = NaN((floor(n-windowsLength)/nshift)+1, windowsLength);

for t = windowsLength : nshift : n
    count = count + 1;
    parityData(count,:) = initData(t-windowsLength+1:t);
end

[a,b] = size(parityData);
y = zeros(1,b);
n = b;
H = zeros(1,a);
t = 1:a;

for i = 1:a
    %count = count +1;
    y  = parityData (i,:); 
    H(i) = perment (y, n);
    
end

%original Data
ax1 = subplot (2,1,1);
plot (ax1, tise, initData)
title(ax1, 'Seismic Data')
xlabel(ax1, 'time')
ylabel(ax1, 'amplitudo')

%permutation result
ax2 = subplot (2,1,2);
plot (ax2, t, H)
title(ax2, 'Permutation Result')
xlabel(ax2, 'time')
ylabel(ax2, 'H')