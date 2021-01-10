clear;

%% 초기값 설정
global x1 y1 Dy1 N a b v;
x1 = 471; %% 도착점 (x1,y1)의 x좌표 값
y1 = 319.5; %% 도착점 (x1,y1)의 y좌표 값
Dy1 = 1.63; %% 도착점 (x1,y1)의 기울기 값
N = 2000; %% 미분방정식 솔버에서 사용할 점의 개수
a = 4.2/3.6; %% 속도식 v = asqrt(r-b)에서 사용되는 a
b = 70; %% 속도식 v = asqrt(r-b)에서 사용되는 b
v = 100/3.6; %% v의 최대값(v_max보다 v가 크면 v를 반환함)

%SRT model: Dy1=0.78 optimal - 56.8979

%% 기타 설정
xmesh = linspace(0,x1,N); 
init = bvpinit(xmesh,@guess);
curvature = zeros(N,1);
speed = zeros(N,1);
time = zeros(N,1);

%% 미분방정식 풀이
sol = bvp4c(@rhs_bvp,@bc_bvp,init);
x = sol.x;
f = sol.y;

%% 곡률/속력/시간 계산
for i = 1:N
    curvature(i) = f(3,i) / (1 + f(2,i)^2)^(3/2);
end

for i = 1:N
    speed(i) = a*(1/curvature(i)-b)^(1/2);
    if speed(i) > v
        speed(i) = v;
    end
end

for i = 1:N
    time(i) = (1 + f(2,i)^2)^(1/2) * x1 / N / speed(i);
end

t = 0;

for i = 1:N
    t = t + time(i);
end

%% 그래프 플롯팅
plot(sol.x, sol.y(1,:));
%plot(sol.x, speed);

%% 경계값 문제의 초기 추측값 (3차 다항식)
function y = guess(x)
global x1 y1;
y = [y1/x1^2*x^2
     2*y1/x1^2*x
     y1/x1^2
     0];
end

%% 경계치 조건을 나타내는 함수
function bc = bc_bvp(yl,yr)
global y1 Dy1;
bc = [yl(1); yl(2); yr(1) - y1; yr(2) - Dy1]; %% (시작점 함수값 = 0 / 시작점 도함수값 = 0 / 도착점 함수값 = y1 / 도착점 도함수값 = Dy1)
end