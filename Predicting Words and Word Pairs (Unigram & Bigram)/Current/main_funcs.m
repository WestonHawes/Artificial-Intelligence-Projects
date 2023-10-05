clear
clc

% Read the text file
fileName = 'room_with_a_view.txt';
str = readTextToStr(fileName);

% Preprocess the text
cleanedStr = preprocessText(str);

% Count the number of words
numWords = countNumWords(cleanedStr);

% Count the number of unique words
numUniqueWords = countNumUniqueWords(cleanedStr);

% Count the number of unique words with a minimum length
minLength = 9;
numUniqueWordsMin = countNumUniqueWordsMin(string(cleanedStr), minLength);

% Count the occurrence of each word (uni-gram)
wordCounts = countUnigram(string(cleanedStr));

% Count the occurrence of each pair of words (bi-gram)
[wordPairs, counts] = countBigram(string(cleanedStr));

% Generate text based on the probability of the words
startWord = 'the';
numWordsGenerated = 5;
generatedText = generateText(wordPairs, counts, startWord, numWordsGenerated);

maxWordLength = 3;
endWords = {'they', 'went'};
% Call generateText function with the inputs
generatedTextImproved = generateTextImproved(wordPairs, counts, startWord, numWords, maxWordLength, endWords);

% Plot the distribution of the unique words
figure;
plotUniqueWordsByOccurence(string(cleanedStr));
figure;
plotUniqueWordsByFrequency(string(cleanedStr));
% Plot the bigram occurrences
figure;
plotBigramByOccurrence(wordPairs, counts);
figure;
plotBigramByFrequency(wordPairs, counts);


% preprocess text
function [cleanedString] = preprocessText(strParam)
    % Convert to lowercase
    cleanedString = lower(strParam);
    % Remove special characters and numbers
    cleanedString = regexprep(cleanedString, '[^a-zA-Z\s]', '');
    % Remove extra whitespaces
    cleanedString = regexprep(cleanedString, '\s+', ' ');
    % Split the string into words
    cleanedString = strsplit(cleanedString);
end

%read the textfile containing the book 
function [string] = readTextToStr(fileName)
    % Read the text file
    fileId = fopen(fileName,'r');
    string = fread(fileId,'*char')';
    fclose(fileId);
end

% get the number of unique words
function [numUniqueWords] = countNumUniqueWords(stringArray)
    numUniqueWords = length(unique(stringArray));
end

% get the number of unique words where you specify as an option the minimum number of characters in the word
function [numUniqueWords] = countNumUniqueWordsMin(stringArray, minLength)
    % Remove words with length less than minLength
    stringArray(cellfun('length', stringArray) < minLength) = [];
    numUniqueWords = length(unique(stringArray));
end

%count the number of words
function [numWords] = countNumWords(stringArray)
    numWords = length(stringArray);
end

% Create a function to count the occurrence of each word (uni-gram)
function [uniqueWords, counts] = countUnigram(stringArray)
% COUNTUNIGRAM Count the occurrences of each unique word in a cell array of strings
%   [uniqueWords, counts] = countUnigram(stringArray) returns two output arrays:
%   uniqueWords, a cell array of unique words in stringArray, and counts, an array of
%   corresponding counts of the number of times each word appears in stringArray.

    % Combine all the strings into a single document
    doc = join(stringArray);

    % Tokenize the document into words
    words = split(doc);

    % Count the occurrences of each unique word
    [uniqueWords, ~, idx] = unique(words);
    counts = accumarray(idx, 1);

    % Sort the words and counts in descending order of frequency
    [counts, idx] = sort(counts, 'descend');
    uniqueWords = uniqueWords(idx);

end

% Create a function to get a matrix to get the number of words, based on the previous word. (bi-gram)
function [wordPairs, counts] = countBigram(stringArray)
    % Create word pairs
    wordPairs = [stringArray(1:end-1)', stringArray(2:end)'];
    % Get unique word pairs and counts
    [wordPairs, ~, idx] = unique(wordPairs, 'rows');
    counts = accumarray(idx, 1);
end

% Create a function that generates text based on the probability of the words, using the previous word as prior information
function [generatedText] = generateText(wordPairs, counts, startWord, numWords)
    generatedText = startWord;
    currentWord = startWord;
    for i = 1:numWords
        % Get possible next words
        possibleNextWords = wordPairs(:,1) == currentWord;
        if sum(possibleNextWords) == 0
            break;
        end
        possibleWordPairs = wordPairs(possibleNextWords,:);
        possibleCounts = counts(possibleNextWords);
        % Calculate probabilities
        probabilities = possibleCounts / sum(possibleCounts);
        % Choose the next word based on the probabilities
        chosenIndex = find(rand < cumsum(probabilities), 1);
        chosenPair = possibleWordPairs(chosenIndex,:);
        % Check that chosenPair has at least two elements
        if numel(chosenPair) < 2
            break;
        end
        chosenWord = chosenPair(2);
        generatedText = [generatedText ' ' chosenWord];
        currentWord = chosenWord;
    end
end

%improved generateText function
function [generatedText] = generateTextImproved(wordPairs, counts, startWord, numWords, maxWordLength, endWords)
% Generate text based on the probability of the words, using the previous word as prior information

% Initialize variables
generatedText = startWord;
currentWord = startWord;

% Generate text
for i = 1:numWords
    % Get possible next words
    possibleNextWords = wordPairs(:,1) == currentWord;
    if sum(possibleNextWords) == 0
        break;
    end
    possibleWordPairs = wordPairs(possibleNextWords,:);
    possibleCounts = counts(possibleNextWords);
    
    % Filter out words that are too long
    possibleWords = possibleWordPairs(:,2);
    validLengths = cellfun(@length, possibleWords) <= maxWordLength;
    possibleWordPairs = possibleWordPairs(validLengths,:);
    possibleCounts = possibleCounts(validLengths);
    
    % Filter out end words if the generated text is not long enough yet
    if i < numWords
        possibleWords = possibleWordPairs(:,2);
        validEndWords = ~ismember(possibleWords, endWords);
        possibleWordPairs = possibleWordPairs(validEndWords,:);
        possibleCounts = possibleCounts(validEndWords);
    end
    
    % Calculate probabilities
    probabilities = possibleCounts / sum(possibleCounts);
    
    % Choose the next word based on the probabilities
    chosenIndex = find(rand < cumsum(probabilities), 1);
    chosenPair = possibleWordPairs(chosenIndex,:);
    
    % Check that chosenPair has at least two elements
    if numel(chosenPair) < 2
        break;
    end
    
    % Update generated text and current word
    chosenWord = chosenPair{2};
    generatedText = [generatedText ' ' chosenWord];
    currentWord = chosenWord;
    
    % Check if generated text can end
    if ismember(chosenWord, endWords)
        break;
    end
end

end
% Create a function to plot the distribution of the unique words
function plotUniqueWordsByOccurence(stringArray)
    % Get the unique words and their counts
    [uniqueWords, counts] = countUnigram(stringArray);
    % Plot the bar graph
    bar(counts);
    % Set ticks
    % Set the x-axis label
    xlabel('Unique Words');
    % Set the y-axis label
    ylabel('Number of Occurrences');
    % Set the title
    title('Distribution of Unique Words By Occurence');
    % Set the x-axis tick labels to the unique words
    xticks(1:length(uniqueWords));
    xticklabels(uniqueWords);
    % Rotate the x-axis tick labels to make them readable
    xtickangle(90);
    % Set the x-axis limits to show only the first 40 xticks
    xlim([0 40]);

end

function plotBigramByFrequency(wordPairs, counts)
    % Calculate the frequency of each bigram
    freq = counts / sum(counts) ;
    %arraySum sumbs to 1.00, all freq are accounted for
    arraySum = sum(freq);
    % Sort the bigrams by frequency
    [freq, idx] = sort(freq, 'descend');
    wordPairs = wordPairs(idx,:);
    counts = counts(idx);

    % Plot the bigram frequency distribution
    bar(freq);
    xticklabels = strcat(wordPairs(:,1), " ", wordPairs(:,2));
    set(gca, 'xtick', 1:numel(freq), 'xticklabel', xticklabels, 'XTickLabelRotation', 90, 'xlim', [1, 40]);
    xlabel('Bigram');
    ylabel('Frequency');
    title('Bigram Frequency Distribution');
    
    % Set the x-axis limits to show only the first 40 ticks
    xlim([1 40]);
end
% Create a function to plot the distribution of the unique words by frequency
function plotUniqueWordsByFrequency(stringArray)
    % Get the unique words and their counts
    [uniqueWords, counts] = countUnigram(stringArray);
    % Calculate the frequency of each unique word
    freq = counts / sum(counts);
    % Sort the unique words by frequency
    [freq, idx] = sort(freq, 'descend');
    uniqueWords = uniqueWords(idx);
    % Plot the bar chart
    bar(freq);
    % Set the x-axis tick labels to the unique words
    xticks(1:length(uniqueWords));
    xticklabels(uniqueWords);
    % Rotate the x-axis tick labels to make them readable
    xtickangle(90);
    % Set the x-axis label
    xlabel('Unique Words');
    % Set the y-axis label
    ylabel('Frequency');
    % Set the title
    title('Distribution of Unique Words by Frequency');
    % Set the x-axis limits to show only the first 40 ticks
    xlim([1 40]);
end

% Create a function to plot the distribution of bigrams by occurrence
function plotBigramByOccurrence(wordPairs, counts)
    % Sort the bigrams by occurrence
    [counts, idx] = sort(counts, 'descend');
    wordPairs = wordPairs(idx,:);
    % Plot the bar chart
    bar(counts);
    % Set the x-axis tick labels to the bigrams
    xticklabels = strcat(wordPairs(:,1), " ", wordPairs(:,2));
    set(gca, 'xtick', 1:numel(counts), 'xticklabel', xticklabels, 'XTickLabelRotation', 90, 'xlim', [1, 40]);
    % Set the x-axis label
    xlabel('Bigram');
    % Set the y-axis label
    ylabel('Number of Occurrences');
    % Set the title
    title('Distribution of Bigrams by Occurrence');
    % Set the x-axis limits to show only the first 40 ticks
    xlim([1 40]);
end
