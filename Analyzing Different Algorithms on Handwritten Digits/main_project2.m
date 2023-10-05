clear
clc
maxNumCompThreads(4);
load('mnist.mat'); % Load the MNIST dataset

num_train = 500; % Number of training examples per class
num_val = 100; % Number of validation examples per class
num_test = 500; % Number of test examples per class

X_train_orig = double(reshape(training.images, 28*28, []))'; % Reshape and convert training images to double
y_train_orig = double(training.labels); % Get training labels


X_test_orig = double(reshape(test.images, 28*28, []))'; % Reshape and convert test images to double
y_test_orig = double(test.labels); % Get test labels

X_train = []; % Initialize training data
y_train = []; % Initialize training labels
X_val = []; % Initialize validation data
y_val = []; % Initialize validation labels
X_test = []; % Initialize test data
y_test = []; % Initialize test labels

% Loop over all classes
for i = 0:9
    % Get indices of training, validation, and test examples for this class
    idx_train = find(y_train_orig == i);
    idx_val = idx_train(num_train+1:num_train+num_val);
    idx_train = idx_train(1:num_train);
    idx_test = find(y_test_orig == i);
    idx_test = idx_test(1:num_test);
    
    % Select num_train examples for training, num_val examples for validation, and num_test examples for testing
    X_train_class = X_train_orig(idx_train, :);
    y_train_class = y_train_orig(idx_train);
    X_val_class = X_train_orig(idx_val, :);
    y_val_class = y_train_orig(idx_val);
    X_test_class = X_test_orig(idx_test, :);
    y_test_class = y_test_orig(idx_test);
    
    % Normalize data using max-min normalization
    X_train_class_norm = (X_train_class - min(X_train_class(:))) / (max(X_train_class(:)) - min(X_train_class(:)));
    X_val_class_norm = (X_val_class - min(X_train_class(:))) / (max(X_train_class(:)) - min(X_train_class(:)));
    X_test_class_norm = (X_test_class - min(X_train_class(:))) / (max(X_train_class(:)) - min(X_train_class(:)));
    
    % Add normalized data and labels to overall training, validation, and test data and labels
    X_train = [X_train; X_train_class_norm];
    y_train = [y_train; y_train_class];
    X_val = [X_val; X_val_class_norm];
    y_val = [y_val; y_val_class];
    X_test = [X_test; X_test_class_norm];
    y_test = [y_test; y_test_class];


end


% k-nearest neighbor (k-NN) classifier

k_values = [1, 5, 10];
for k = k_values
    y_pred = zeros(size(y_test));
    for i = 1:size(X_test, 1)
        % Calculate the Euclidean distance between the test sample and all training samples
        distances = sqrt(sum((X_train - X_test(i, :)).^2, 2));
        
        % Get the indices of the k nearest neighbors
        [~, indices] = mink(distances, k);
        
        % Get the labels of the k nearest neighbors
        labels = y_train(indices);
        
        % Predict the class of the test sample as the majority class among the k nearest neighbors
        y_pred(i) = mode(labels);
    end
    % Calculate the confusion matrix
    confMat = confusionmat(y_test,y_pred);
    disp(['k-NN classifier with k = ', num2str(k), ', confusion matrix:']);
    disp(confMat);
    %display accuracy
    accuracy = sum(y_pred == y_test) / length(y_test);
    fprintf('k-NN classifier with k = %d, accuracy = %.2f%%\n', k, accuracy*100);
end


% k-means clustering for supervised classification

% Set the values of k for which to test
% Set parameters
n_iterations_max = 20;
% Set the values of k for which to test
Ks = [10, 20, 30];

% Initialize accuracies
accuracies = zeros(length(Ks), 1);

% Loop over Ks
for i = 1:length(Ks)
    k = Ks(i);

    % Train k-means on training data
    [idx, C] = kmeans(X_train, k,n_iterations_max);

    % Assign labels to clusters based on closest training example
    cluster_labels = zeros(k, 1);
    for j = 1:k
        idx_cluster = find(idx == j);
        y_cluster = y_train(idx_cluster);
        unique_labels = unique(y_cluster);
        counts = histc(y_cluster, unique_labels);
        [~, max_idx] = max(counts);
        cluster_labels(j) = unique_labels(max_idx);
    end

    % Test on test data
    y_pred = zeros(size(X_test, 1), 1);
    for j = 1:size(X_test, 1)
        distances = sum((C - X_test(j,:)).^2, 2);
        [~, min_idx] = min(distances);
        y_pred(j) = cluster_labels(min_idx);
    end

    % Compute accuracy
    accuracies(i) = sum(y_pred == y_test) / length(y_test);
    % Compute confusion matrix
    conf_matrix = confusionmat(y_test, y_pred);

    % Display confusion matrix
    disp(['Confusion matrix for k = ' num2str(k) ':']);
    disp(conf_matrix);
end

% Display results
disp(['Accuracy for k = 10: ' num2str(accuracies(1)*100) '%']);
disp(['Accuracy for k = 20: ' num2str(accuracies(2)*100) '%']);
disp(['Accuracy for k = 30: ' num2str(accuracies(3)*100) '%']);



% Multilayer perceptron (MLP) classifier
% Set the number of neurons in the hidden layers
hidden_sizes = [50, 100];

% Train a MLP with each number of neurons in the hidden layer
for hi = 1:length(hidden_sizes)
    hidden_size = hidden_sizes(hi);
    disp(['Training MLP with hidden size = ', num2str(hidden_size)]);
    
    % Encode the labels using one-hot encoding (replaces categorical)
    y_train_onehot = full(sparse(1:length(y_train), y_train+1, 1));
    y_test_onehot = full(sparse(1:length(y_test), y_test+1, 1));
    
    % Define the MLP architecture
    net = patternnet(hidden_size);

    % Train the MLP using the training data
    net = train(net, X_train', y_train_onehot');
    
    % Test the MLP using the test data
    y_pred_onehot = net(X_test');
    [~, y_pred] = max(y_pred_onehot);
    y_pred = y_pred - 1;
    
    % Compute the accuracy
    accuracy = sum(y_pred' == y_test) / length(y_test);
    disp(['Accuracy with hidden size = ', num2str(hidden_size), ': ', num2str(accuracy * 100), '%']);

    % Create confusion matrix
    C = confusionmat(y_test, y_pred);
    disp('Confusion matrix:');
    disp(C);
end


% Convolutional neural network (CNN) classifier
% Split data into training, validation and testing sets

X_train = X_train';
y_train = categorical(y_train');
X_val = X_val';
y_val = categorical(y_val');
X_test = X_test';
y_test = categorical(y_test');

% Normalize data using max-min normalization
X_train = (X_train - min(X_train(:))) ./ (max(X_train(:)) - min(X_train(:)));
X_val = (X_val - min(X_train(:))) ./ (max(X_train(:)) - min(X_train(:)));
X_test = (X_test - min(X_train(:))) ./ (max(X_train(:)) - min(X_train(:)));


% Convert X data back to 4d
X_test = reshape(X_test, 28, 28, 1, []);
X_train = reshape(X_train, 28, 28, 1, []);
X_val = reshape(X_val, 28, 28, 1, []);
% Convert labels to categorical format
y_val_cat = categorical(y_val);
y_train_cat = categorical(y_train);
y_test_cat = categorical(y_test);


% Define layers
layers = [    imageInputLayer([28 28 1])
    convolution2dLayer(5, 20)
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

% Define options for training
options = trainingOptions('sgdm', ...
    'MaxEpochs', 25, ...
    'MiniBatchSize', 128, ...
    'ValidationData', {X_val, y_val_cat}, ...
    'ValidationFrequency', 25, ...
    'Plots', 'training-progress');


% Train the network
net = trainNetwork(X_train, y_train_cat, layers, options);

% Test the network using the test data
y_pred = classify(net, X_test);
conf_mat = confusionmat(y_test, y_pred);

% Display the confusion matrix
disp('Confusion Matrix:');
disp(conf_mat);

%Y_pred = classify(net, X_test);
%accuracy = sum(Y_pred == y_test) / numel(y_test);
%fprintf('Accuracy: %.2f%%\n', accuracy*100);
