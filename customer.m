%initial values
clc
clear
close all
rng(0)
N = 900;
iteration = 150;

%--------------------------social----------------------

%parameters and initial values
mean = 0.5.*randn(5,1) + 0.35;
degree = zeros(N,5);
degree(:,1) = mean(1).*randn(N,1) + 0.35;
degree(:,2) = mean(2).*randn(N,1) + 0.35;
degree(:,3) = mean(3).*randn(N,1) + 0.35;
degree(:,4) = mean(4).*randn(N,1) + 0.35;
degree(:,5) = mean(5).*randn(N,1) + 0.35;

attr   = rand(N,3);
C = zeros(N,N);
%case 1 (01) (-10)
%case 2 (-10) (01)
%case 3 (-11) (-11)
low_opi = -1; %min
high_opi = 1; %max
low_cpi = -1;
high_cpi = 1;
k_opi = (high_opi-low_opi).*rand(N,1) + low_opi;
k_cpi = (high_cpi-low_cpi).*rand(N,1) + low_cpi;
degree(degree<0) = 0;
degree(degree>1) = 1;
entropy = zeros(5,iteration);

n = 35;
for i=1:n
    j = randi([1,N]);
    while k_opi(j)==0
        j=randi([1,N]);
    end
    k_opi(j) = 0;
    k_cpi(j) = 0;
end

D = zeros(N,N);
%connection
for j=1:N
    for k=1:N
        if j~=k
            strength = attr(j,1)*attr(k,1) + attr(j,2)*attr(k,2) + attr(j,3)*attr(k,3);
            D(j,k) = strength;
            if (1.5<strength)&&(strength<=3)
                C(j,k) = 2;
            elseif (0<strength)&&(strength)<=1.5
                C(j,k) = 1;
            end
        end
    end
end
alpha_matrix = zeros(N,iteration);
beta_matrix = zeros(N,iteration);
gamma_matrix = zeros(N,iteration);
degree_matrix = zeros(N,iteration);
degree_history = zeros(N,iteration,5);
clf_history = zeros(N,iteration,5);
clf = zeros(N,5);

history = zeros(5,iteration,5);
average = zeros(N,iteration);


%------------------------------end----------------------------

%----------------------------economy-----------------------
%parameters and initial values
mean_class = 0.456;
class = mean_class.*randn(N,1) + 0.355;
%produk 1&2-> kelas 1
%produk 3&4-> kelas 2
%produk 5  -> kelas 3

for i=1:N
    if class(i)<=0.33
        class(i) = 1;
    elseif class(i)>0.33 && class(i)<=0.7
        class(i) = 2;
    elseif class(i)>0.7
        class(i) = 3;
    end
end

mean_eco = 0.5.*randn(5,1) + 0.35;
degree_eco = zeros(N,5);
degree_eco(:,1) = mean_eco(1).*randn(N,1) + 0.35;
degree_eco(:,2) = mean_eco(2).*randn(N,1) + 0.35;
degree_eco(:,3) = mean_eco(3).*randn(N,1) + 0.35;
degree_eco(:,4) = mean_eco(4).*randn(N,1) + 0.35;
degree_eco(:,5) = mean_eco(5).*randn(N,1) + 0.35;

attr_eco   = rand(N,3);
attr_eco(:,3) = class(:);
C_eco = zeros(N,N);
low_eopi = -1; %min
high_eopi = 1; %max
low_ecpi = -1;
high_ecpi = 1;
k_eopi = (high_eopi-low_eopi).*rand(N,1) + low_eopi;
k_ecpi = (high_ecpi-low_ecpi).*rand(N,1) + low_ecpi;
degree_eco(degree_eco<0) = 0;
degree_eco(degree_eco>1) = 1;
%entropy = zeros(5,iteration);

n = 35;
for i=1:n
    j = randi([1,N]);
    while k_eopi(j)==0
        j=randi([1,N]);
    end
    k_eopi(j) = 0;
    k_ecpi(j) = 0;
end
De = zeros(N,N);
num_product = 5;
attr_prod = zeros(num_product,3); %3 for price, related to economy class of agent
attr_prod(1,3) = 1; attr_prod(2,3) = 1;
attr_prod(3,3) = 2; attr_prod(4,3) = 2;
attr_prod(5,3) = 3;

%connection to product
for j=1:N
    for k=1:num_product
        if j~=k
            strength = attr_eco(j,1)*attr_prod(k,1) + attr_eco(j,2)*attr_prod(k,2);
            if attr_eco(j,3) == attr_prod(k,3)
                strength = strength + 1;
            end
            D_eco(j,k) = strength;
            if (1.5<strength)&&(strength<=3)
                C_eco(j,k) = 2;
            elseif (0<strength)&&(strength)<=1.5
                C_eco(j,k) = 1;
            end
        end
    end
end
alpha_eco_matrix = zeros(N,iteration);
beta_eco_matrix = zeros(N,iteration);
gamma_eco_matrix = zeros(N,iteration);
degree_eco_matrix = zeros(N,iteration);
degree_eco_history = zeros(N,iteration,5);
clf_eco_history = zeros(N,iteration,5);
clf_eco = zeros(N,5);

history_eco = zeros(5,iteration,5);
average_eco = zeros(N,iteration);

prob_decision = zeros(N,iteration,5);
%--------------------------------end----------------------------------

%----------------- simulation-------------------------------------
for i=1:iteration
    for product=1:5
        for j=1:N
            if degree(j,product)>0.8
                clf(j,product) = 5;
            elseif (0.6<degree(j,product))&&(degree(j,product)<=0.8)
                clf(j,product) = 4;
            elseif (0.4<degree(j,product))&&(degree(j,product)<=0.6)
                clf(j,product) = 3;
            elseif (0.2<degree(j,product))&&(degree(j,product)<=0.4)
                clf(j,product) = 2;
            elseif degree(j,product)<0.2
                clf(j,product) = 1;
            end
        end
        
        history(1,i,product) = sum(clf(:,product)==1);
        history(2,i,product) = sum(clf(:,product)==2);
        history(3,i,product) = sum(clf(:,product)==3);
        history(4,i,product) = sum(clf(:,product)==4);
        history(5,i,product) = sum(clf(:,product)==5);
        clf_history(:,i,product) = clf(:,product);
        degree_history(:,i,product) = degree(:,product);
        
        if sum(history(:,i,product)) ~= N
            disp([i,product])
        end
        
        alpha = 0;
        beta = 0;
        gamma = 0;
        avg = 0;
        average(:,i) = sum(C,2);
        
        for j=1:N
            for k=1:N
                if j~=k
                    alpha = alpha + C(j,k)*attr(j,1);
                    beta = beta + C(j,k)*attr(j,2);
                    gamma = gamma + C(j,k)*attr(j,3);
                    avg = avg + C(j,k)*degree(k,product);
                end
            end
            alpha = alpha/average(j,i);
            beta  = beta/average(j,i);
            gamma = gamma/average(j,i);
            avg   = avg/average(j,i);
            alpha_matrix(j,i) = alpha;
            beta_matrix(j,i)  = beta;
            gamma_matrix(j,i) = gamma;
            degree_matrix(j,i,product) = avg;
        end
        
        degree(:,product) = degree(:,product) + k_opi.*(degree_matrix(:,i,product) - degree(:,product));
        attr(:,1) = attr(:,1) + k_cpi.*(alpha_matrix(:,i) - attr(:,1));
        attr(:,2) = attr(:,2) + k_cpi.*(beta_matrix(:,i) - attr(:,2));
        attr(:,3) = attr(:,3) + k_cpi.*(gamma_matrix(:,i) - attr(:,3));
        
        for j=1:N
            for k=1:N
                if j~=k
                    strength = attr(j,1)*attr(k,1) + attr(j,2)*attr(k,2) + attr(j,3)*attr(k,3);
                    D(j,k) = strength;
                    if (1.5<strength)&&(strength<=3)
                        C(j,k) = 2;
                    elseif (0<strength)&&(strength)<=1.5
                        C(j,k) = 1;
                    end
                end
            end
        end
        attr(attr<0) = 0; attr(attr>1) = 1;
        degree(degree<0) = 0; degree(degree>1)=1;
        
        %-------------------------------
        for j=1:N
            if degree_eco(j,product)>0.8
                clf_eco(j,product) = 5;
            elseif (0.6<degree_eco(j,product))&&(degree_eco(j,product)<=0.8)
                clf_eco(j,product) = 4;
            elseif (0.4<degree_eco(j,product))&&(degree_eco(j,product)<=0.6)
                clf_eco(j,product) = 3;
            elseif (0.2<degree_eco(j,product))&&(degree_eco(j,product)<=0.4)
                clf_eco(j,product) = 2;
            elseif degree_eco(j,product)<0.2
                clf_eco(j,product) = 1;
            end
        end
        
        history_eco(1,i,product) = sum(clf_eco(:,product)==1);
        history_eco(2,i,product) = sum(clf_eco(:,product)==2);
        history_eco(3,i,product) = sum(clf_eco(:,product)==3);
        history_eco(4,i,product) = sum(clf_eco(:,product)==4);
        history_eco(5,i,product) = sum(clf_eco(:,product)==5);
        clf_eco_history(:,i,product) = clf_eco(:,product);
        degree_eco_history(:,i,product) = degree_eco(:,product);
        
        if sum(history_eco(:,i,product)) ~= N
            disp([i,product])
        end
        
        alpha_eco = 0;
        beta_eco = 0;
        gamma_eco = 0;
        avg_eco = 0;
        average_eco(:,i) = sum(C_eco,2);
        
        for j=1:N
            for k=1:N
                if j~=k
                    alpha_eco = alpha_eco + C_eco(j,k)*attr_eco(j,1);
                    beta_eco = beta_eco + C_eco(j,k)*attr_eco(j,2);
                    gamma_eco = gamma_eco + C_eco(j,k)*attr_eco(j,3);
                    avg_eco = avg_eco + C_eco(j,k)*degree_eco(k,product);
                end
            end
            alpha_eco = alpha_eco/average_eco(j,i);
            beta_eco  = beta_eco/average_eco(j,i);
            gamma_eco = gamma_eco/average_eco(j,i);
            avg_eco   = avg_eco/average_eco(j,i);
            alpha_eco_matrix(j,i) = alpha_eco;
            beta_eco_matrix(j,i)  = beta_eco;
            gamma_eco_matrix(j,i) = gamma_eco;
            degree_eco_matrix(j,i,product) = avg_eco;
        end
        
        degree_eco(:,product) = degree_eco(:,product) + k_eopi.*(degree_eco_matrix(:,i,product) - degree_eco(:,product));
        attr_eco(:,1) = attr_eco(:,1) + k_ecpi.*(alpha_eco_matrix(:,i) - attr_eco(:,1));
        attr_eco(:,2) = attr_eco(:,2) + k_ecpi.*(beta_eco_matrix(:,i) - attr_eco(:,2));
        attr_eco(:,3) = attr_eco(:,3) + k_ecpi.*(gamma_eco_matrix(:,i) - attr_eco(:,3));
        
        for j=1:N
            for k=1:5
                if j~=k
                    strength = attr_eco(j,1)*attr_prod(k,1) + attr_eco(j,2)*attr_prod(k,2);
                    if attr_eco(j,3) == attr_prod(k,3)
                        strength = strength + 1;
                    end
                    D_eco(j,k) = strength;
                    if (1.5<strength)&&(strength<=3)
                        C_eco(j,k) = 2;
                    elseif (0<strength)&&(strength)<=1.5
                        C_eco(j,k) = 1;
                    end
                end
            end
        end
        attr_eco(attr_eco<0) = 0; attr_eco(attr_eco>1) = 1;
        degree_eco(degree_eco<0) = 0; degree_eco(degree_eco>1)=1;
        %---------------------------------
    end
end

prob_decision = 0.5.*(degree_eco_history + degree_history);
product_decision = zeros(N,iteration);
product_history = zeros(5,iteration);
for i=1:iteration
    for j=1:N
        greatest = -100;
        code = 0;
        for k=1:5
            if prob_decision(j,i,k)> greatest
                greatest = prob_decision(j,i,k);
                code = k;
            end
        end
        product_decision(j,i) = code;
    end
    product_history(1,i) = sum(product_decision(:,i)==1);
    product_history(2,i) = sum(product_decision(:,i)==2);
    product_history(3,i) = sum(product_decision(:,i)==3);
    product_history(4,i) = sum(product_decision(:,i)==4);
    product_history(5,i) = sum(product_decision(:,i)==5);
end
x = linspace(1,iteration,iteration);

for i=1:5
    figure(i)
    set(gcf,'Position',[300 30 800,650])
    subplot(3,1,1)
    plot(x,product_history(i,:),'linewidth',1.2)
    title(int2str(i))
    
    subplot(3,1,2)
    plot(x,history(:,:,i),'linewidth',1.2)
    title('Social-based Opinion')
    %legend('Not Interested at all','Not Interested','Neutral','Interested','Very Interested')
    
    subplot(3,1,3)
    plot(x,history_eco(:,:,i),'linewidth',1.2)
    title('Economic-based Opinion')
    legend('Not Interested at all','Not Interested','Neutral','Interested','Very Interested')
    
    savefig(['case 3-3 with stubborn/' int2str(i) '.fig'])
end
% figure(1)
% plot(x,product_history(1,:),'linewidth',1.2)
% hold on
% plot(x,product_history(2,:),'linewidth',1.2)
% hold on
% plot(x,product_history(3,:),'linewidth',1.2)
% hold on
% plot(x,product_history(4,:),'linewidth',1.2)
% hold on
% plot(x,product_history(5,:),'linewidth',1.2)
% legend('I','II','III','IV','V')
% title('Number of Agents Product Decision')
% xlabel('Iteration')
% ylabel('Number of Agents')
% ylim([0,N])
% for i=2:6
%      figure(i)
%      plot(x,history_eco(1,:,i-1),'linewidth',1.2)
%      title('Product 1 Public Opinion')
%      hold on
%      plot(x,history_eco(2,:,i-1),'linewidth',1.2)
%      title('Product 2 Public Opinion')
%     hold on
%     plot(x,history_eco(3,:,i-1),'linewidth',1.2)
%     title('Product 3 Public Opinion')
%     hold on
%     plot(x,history_eco(4,:,i-1),'linewidth',1.2)
%     title('Product 4 Public Opinion')
%     hold on
%     plot(x,history_eco(5,:,i-1),'linewidth',1.2)
%     title('Product 5 Public Opinion')
%     hold on
%     legend('Hate','Not Interested','Neutral','Interested','Very Interested')
%     
%     xlabel('Iteration')
%     ylabel('Number of Agents')
%     ylim([0,N])
% end
% 
% for i=7:11
%      figure(i)
%      plot(x,history(1,:,i-6),'linewidth',1.2)
%      title('Product 1 Public Opinion')
%      hold on
%      plot(x,history(2,:,i-6),'linewidth',1.2)
%      title('Product 2 Public Opinion')
%     hold on
%     plot(x,history(3,:,i-6),'linewidth',1.2)
%     title('Product 3 Public Opinion')
%     hold on
%     plot(x,history(4,:,i-6),'linewidth',1.2)
%     title('Product 4 Public Opinion')
%     hold on
%     plot(x,history(5,:,i-6),'linewidth',1.2)
%     title('Product 5 Public Opinion')
%     hold on
%     legend('Hate','Not Interested','Neutral','Interested','Very Interested')
%     
%     xlabel('Iteration')
%     ylabel('Number of Agents')
%     ylim([0,N])
% end
% %savefig('number agents case 5.fig')
%
% % figure(2)
% % plot(x,entropy(1,:),'linewidth',1.2)
% % hold on
% % plot(x,entropy(2,:),'linewidth',1.2)
% % hold on
% % plot(x,entropy(3,:),'linewidth',1.2)
% % hold on
% % plot(x,entropy(4,:),'linewidth',1.2)
% % hold on
% % plot(x,entropy(5,:),'linewidth',1.2)
% % legend('I','II','III','IV','V')
% % title('entropy')
% % xlabel('Iteration')
% % ylabel('Sk')
% % ylim([0,0.2])
% % savefig('entropy case 5.fig')
%
% % figure(3)
% %
% % plot(x,sum(entropy),'linewidth',1.2)
% % title('total entropy')
% % xlabel('Iteration')
% % ylabel('S')
% % ylim([0,1])
% % savefig('Total entropy case 5.fig')

history(1,iteration,1)+history(2,iteration,1)+history(3,iteration,1)+history(4,iteration,1)+history(5,iteration,1)
history(1,iteration,2)+history(2,iteration,2)+history(3,iteration,2)+history(4,iteration,2)+history(5,iteration,2)
history(1,iteration,3)+history(2,iteration,3)+history(3,iteration,3)+history(4,iteration,3)+history(5,iteration,3)
history(1,iteration,4)+history(2,iteration,4)+history(3,iteration,4)+history(4,iteration,4)+history(5,iteration,4)
history(1,iteration,5)+history(2,iteration,5)+history(3,iteration,5)+history(4,iteration,5)+history(5,iteration,5)

history_eco(1,iteration,1)+history_eco(2,iteration,1)+history_eco(3,iteration,1)+history_eco(4,iteration,1)+history_eco(5,iteration,1)
history_eco(1,iteration,2)+history_eco(2,iteration,2)+history_eco(3,iteration,2)+history_eco(4,iteration,2)+history_eco(5,iteration,2)
history_eco(1,iteration,3)+history_eco(2,iteration,3)+history_eco(3,iteration,3)+history_eco(4,iteration,3)+history_eco(5,iteration,3)
history_eco(1,iteration,4)+history_eco(2,iteration,4)+history_eco(3,iteration,4)+history_eco(4,iteration,4)+history_eco(5,iteration,4)
history_eco(1,iteration,5)+history_eco(2,iteration,5)+history_eco(3,iteration,5)+history_eco(4,iteration,5)+history_eco(5,iteration,5)

product_history(1,iteration)+product_history(2,iteration)+product_history(3,iteration)+product_history(4,iteration)+product_history(5,iteration)
product_history(1,iteration)+product_history(2,iteration)+product_history(3,iteration)+product_history(4,iteration)+product_history(5,iteration)
product_history(1,iteration)+product_history(2,iteration)+product_history(3,iteration)+product_history(4,iteration)+product_history(5,iteration)
product_history(1,iteration)+product_history(2,iteration)+product_history(3,iteration)+product_history(4,iteration)+product_history(5,iteration)
product_history(1,iteration)+product_history(2,iteration)+product_history(3,iteration)+product_history(4,iteration)+product_history(5,iteration)

% ----------------------------end------------------------------
