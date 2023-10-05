close all
clc

%fileID = fopen('the_count_of_monte_cristo.txt','r');
%fclose(fileID);
str = readTextToStr('room_with_a_view.txt');

%put the text into lowercase, remove all punctuation,numbers,most special characters, and newlines
wordArray = extractLowercaseWords(str);

%count Num words
numWords = countNumWords(wordArray);

%get num unique words
%uniqueWordArray = getUniqueWords(wordArray);
numUniqueWords = getNumUniqueWords(wordArray);

%get num unique words with min option
numUniqueWordsMin = getNumUniqueWordsMin(wordArray,10);

%count occurance of each unique word
uniqueArr = occuranceOfEachWord(str);
uniqueWordArr = unique(wordArray);


%count num words per previous word
%prevWordMatrix = occuranceBasedOnPreviousWord(str);

%function that allows to specify the minimum number of characters in each
%unique word (arr) and returns each unique word (arr)
%scan through all strings in array and get thier length and then compare
%that length iwth teh optional minimum parameter and if its length is
%greater, this will push this string into the new array taht this function
%will return

%display
%disp (wordArray);
disp (strlength(wordArray(1,1)));
disp (wordArray(1,10));
disp (wordArray(1,100));
disp (wordArray(1,1000));
disp (numUniqueWords);
disp (numUniqueWordsMin);
disp (numWords);
%disp (uniqueArr);
%disp (prevWordMatrix{1});
%disp (prevWordMatrix{2});
%disp (string(wordArray));

%display frequency of unique words
h = histogram(uniqueArr, length(uniqueArr)); 

%Create a function to read the textfile containing the book 
function [str] = readTextToStr(fileName)
 str = fileread(fileName);
end

%utility function to clean a string to words
function [string] = cleanString(strParam)
 str = lower(strParam);
 str = regexprep(str, '[‘’]', '');
 str = regexprep(str, '\r', ' ');
 str = regexprep(str, '\n', ' ');
 str = strrep(str,char(39),'');
 str =regexprep(str, '[\[\]\(\).,!?;:1234567890#*“”"_%$#]', ' ');
 str = regexprep(str,'—',' ');
 string = str;
end

%Create a function to get all the document in lower case and extract the words 
function [wordArrayReturn] = extractLowercaseWords(strParam)
 str = cleanString(strParam);
 %get word array
 wordArray =  strsplit(str, ' ');
 strip(wordArray);
 %IDX = strcmp(wordArray,'-');
 %TF = cellfun('isempty', IDX);
 %wordArray = wordArray(TF);
 wordArray = wordArray(~cellfun('isempty',wordArray));
 wordArrayReturn = wordArray;
end

%Create a function to count the number of words 
function [numWords] = countNumWords(strArr)
 numWords = length(strArr);
end

%Create a function to get the number of unique words 
function [strNumUniqueWords] = getNumUniqueWords(strWords)
 strNumUniqueWords = countNumWords(unique(strWords));
end

%Create a function to get the number of unique words where you specify as an option the minimum number of characters in the word
function [strUniqueWords] = getNumUniqueWordsMin(strWords,minLength)
 if exist('minLength','var')
 %if minLength specified delete words under minLength

  for n = 1: length(strWords)
   strLength = strlength(strWords(1,n));
   if strLength < minLength
    %strTempArr(1,length(strTempArr)+1)= wordArray(1,n);
    strWords(1,n)={''};
   end
  end
  strUniqueWords = getNumUniqueWords(strWords);
 else
  strUniqueWords = getNumUniqueWords(strWords);
 end
end

%Create a function to count the occurance of each word
function [valueCounts] = occuranceOfEachWord(strParam)
 str = cleanString(strParam);
 wordArr = extractLowercaseWords(strParam);
 uniqueWords = unique(wordArr);
 valueCountsTemp = zeros(1);
 for n =1 : length(uniqueWords)
  valueCountsTemp(n) = count(str,uniqueWords(n));
 end
 valueCounts = valueCountsTemp;
end

%Create a function to get a matrix to get the number of words, based on the previous word. (bi-gram)
%{ 
function prevWordMatrix = occuranceBasedOnPreviousWord(strParam)
 str = cleanString(strParam);
 wordArr = extractLowercaseWords(strParam);
 uniqueWords = unique(wordArr);
 %wordOccurance = occuranceOfEachWord(wordArr);

 %return matrix of [(string)<previous word>,(int)<num of words that can possibly come after>]
 numWordsByPreviousWord = cell(2,5);
 
 valueCountsTemp=zeros(1,1);
 space = {' '};
 strIdx = [];
 count = 1;
 for n =1 : length(wordArr)-1
     %if found, will be storeed
   %strIdx=strfind(strParam,strcat(wordArr(n), space, wordArr(n+1)));
   %scann str and add 1 to the count next to the prev word found in unique
   %matrix

     numWordsByPreviousWord(1,count)= strcat(wordArr(n), space, wordArr(n+1));
     %search the numWords matrix for word combo and if not found create one
     %and add a count to it
     for m=1 : count
      strIdx = strfind( numWordsByPreviousWord(1,m),strcat(wordArr(n), space, wordArr(n+1)));
       % disp('here');
     end
     %disp('not There');
     if length(strIdx) ==0
      numWordsByPreviousWord{2} = 1;
      count = count+1;
      disp(numWordsByPreviousWord);
     else
         tempNum= numWordsByPreviousWord(2,count);
         disp(tempNum);
      numWordsByPreviousWord(2,count) = tempNum{1}+1;
     end

     strIdx=[];
   %valueCountsTemp(n) = count(str,uniqueWords(n));
   %stores the previous word and the number of words that can possible come
   %after
   %numWordsByPreviousWord{1}(n) = uniqueWords(n);
 end
 prevWordMatrix = numWordsByPreviousWord;

 end 
 %}


