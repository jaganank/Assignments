input_sentence=input('Enter a sentence:')
words = input_sentence.split()
word_frequency={}
for word in words:
    word = word.strip('.,?')
    if word in word_frequency:
        word_frequency = word_frequency + 1
    else:
        word_frequency = 1
sorted_word = sorted(word_frequency.items())

for word,word_frequencyq in sorted_word:
    print(f"{word}:{word_frequency}")
        