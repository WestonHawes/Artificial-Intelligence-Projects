function [idx,C,D] = kmeans164(X,k,nmaxiterations)
    %% inputs
    %X: data of size n x m
    %n: number of examples
    %m: number of features
    %k: number of clusters
    %% outputs
    % idx: cluster index for eac example
    %C: matrix containing the centroids for each cluster
    %D: distance between an example to the different centroids
    
    [n,m]=size(X);
    
    idx=zeros(n,1);
    C=zeros(k,m);
    D=zeros(n,k);
    
    %initialization
    
    tmp = randperm(n);
    for i=1:k
           C(i,:)=X(tmp(i),:);
    end
    
    iteration = 0;
    
    idx_old=zeros(n,1);
    finished=false;
    
    while((iteration<nmaxiterations) && ~finished)
        % Assign to each example the corresponding cluster
        for i = 1:n
    
            x = X(i,:);
            d = zeros(k,1); %contains the distances between example i and centroid of cluster j
    
            for j=1:k
                c=C(j,:);
                delta=x-c;
                d(j)=sqrt(delta*delta');
            end
            %Get the cluster with the minimum distance with x
            [vmin,argmin]=min(d);
            idx(i)=argmin;
        end
    
        %% Part 2
        % Adjust the values of each centroSid
        for j=1:k
    
            idx_cluster=find(idx==j);
            Xcluster=X(idx_cluster,:);
    
            c(j,:)=mean(Xcluster,1);
        end
    
        %% Check if done
        delta_idx=idx_old-idx;
        distance_idx=sqrt(delta_idx'*delta_idx);
        if distance_idx==0
            finished=true;
        else
            idx_old=idx;
        end
            iteration=iteration+1;
    end
end

