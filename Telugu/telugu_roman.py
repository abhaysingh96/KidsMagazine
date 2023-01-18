import re
import sys
import random
import string

import pandas as pd



telugu_vowels = ["అ", "ఆ", "ఇ", "ఈ", "ఉ", "ఊ", "ఎ" , "ఏ" , "ఐ" , "ఒ" , "ఓ" , "ఔ" ,"ౕ","ా","ి","ీ","ు","ూ","ె","ే","ై","ొ","ో","ౌ","్ "]
telugu_sonorants = ["ఋ", "ౠ", "ఌ", "ౡ"]
telugu_anuswara = [ "ఁ", "ం" ,"ః"]

telugu_consonants = [
    "క","ఖ","గ","ఘ","ఙ",
    "చ","ఛ","జ","ఝ","ఞ",
    "ట","ఠ","డ","ఢ","ణ",
    "త","థ","ద","ధ","న","ప",
    "ఫ","భ","భ","మ","య",
    "ర","ల","వ","శ","ష","స",
    "హ","ళ","క్ష","ఱ",
]
"""
print("Roman characters")
roman_chars = string.ascii_letters[:26]
for i, roman_char in enumerate(roman_chars):
    print((roman_char, len(roman_char.encode('utf8'))), end=" ")
    if (i+1)%10 == 0:
        print()
print()

print("\nTelugu characters")
devanagari_chars = hin_vowels + hin_sonorants + hin_anuswara + hin_consonants
for i, devanagari_char in enumerate(devanagari_chars):
    print((devanagari_char, len(devanagari_char.encode('utf8'))), end=" ")
    if (i+1)%10 == 0:
        print()
print()
"""
telugu2itran_vowels = {
    "అ": "a",
    "ఆ": "A",
    "ఇ": "i",
    "ఈ": "I",
    "ఉ": "u",
    "ఊ": "uu",
    "ఎ": "e",
    "ఏ": "E",
    "ఐ": "ai",
    "ఒ": "o",
    "ఓ": "O",
    "ఔ": "au",
    "ౕ": "a",
    "ా": "A",
    "ి": "e",
    "ీ": "ii",
    "ు": "u",
    "ూ": ".U",
    "ె": "ai",
    "ే": "aI",
    "ై": "ae",
    "ొ": "au",
    "ో": "aU",
    "ౌ": "ou",
    "్ " : ""
}
telugu2itran_anuswara ={
    "ఁ" : "",
     "ం" : "om",
     "ః" : ".N"
}
telugu2itran_sonorants = {
    "ఋ": "RRi",
    "ౠ": "RRI",
    "ఌ": "LLi",
    "ౡ": "LLI",
}
telugu2itran_consonants = {
    "క": "k",
    "ఖ": "kh",
    "గ": "g",
    "ఘ": "gh",
    "ఙ": "N",
    "చ": "ch",
    "ఛ": "C",
    "జ": "j",
    "ఝ": "jh",
    "ఞ": "n",
    "ట": "T",
    "ఠ": "Th",
    "డ": "D",
    "ఢ": "Dh",
    "ణ": "N",
    "త": "t",
    "థ": "th",
    "ద": "d",
    "ధ": "dh",
    "న": "n",
    "ప": "p",
    "ఫ": "ph",
    "బ": "b",
    "భ": "bh",
    "మ": "m",
    "య": "y",
    "ర": "r",
    "ల": "l",
    "వ" : "v",
    "శ": "sh",
    "ష": "sh",
    "స": "s",
    "హ": "h",
    "ళ" : "L",
    "క్ష": "ksh",
    "ఱ": "R",
    "౦": "0",
    "౧": "1",
    "౨": "2",
    "౩": "3",
    "౪": "4",
    "౫": "5",
    "౬": "6",
    "౭": "7",
    "౮": "8",
    "౯": "9",
}


telugu2itran_all = {
    **telugu2itran_vowels, **telugu2itran_anuswara,
    **telugu2itran_sonorants, **telugu2itran_consonants,
    
}

def is_vowel_telugu(char):
    """
    Checks if the character is a vowel.
    """
    if char in telugu2itran_anuswara or char in telugu2itran_vowels:
        return True
    return False


def telugu2itran(telugu_string):
    """
    Converts the Hindi string to the WX string.

    This function goes through each character from the tel_string and
    maps it to a corresponding Roman character according to the
    Devanagari to Roman character mapping defined previously.
    """
    itran_string = []
    for i, current_char in enumerate(telugu_string[:-1]):
        # skipping over the character as it's not included
        # in the mapping
        if current_char == "!":
            continue

      
        # get the Roman character for the Devanagari character
        if current_char in telugu2itran_all:
            itran_string.append(telugu2itran_all[current_char])
        else:
            itran_string.append(current_char)    

        # Handling of "a" sound after a consonant if the next
        # character is not “ఁ" which makes the previous character half
        #if is_vowel_telugu(current_char):
           #itran_string.append(telugu2itran_all[current_char])
          

        if not is_vowel_telugu(current_char):
            if telugu_string[i+1] != "!" and not is_vowel_telugu(telugu_string[i+1]):
                itran_string.append(telugu2itran_all["అ"])
        if is_vowel_telugu(telugu_string[-1]):
           itran_string.append(telugu2itran_all[telugu_string[-1]])
    #if not is_vowel_telugu(telugu_string[-1]):
        #itran_string.append(telugu2itran_all["అ"])
    #if telugu_string[-1] not in telugu2itran_all:
        #itran_string.append(telugu_string[-1])    
    itran_string = "".join(itran_string)

    # consonant + anuswara should be replaced by
    # consonant + "a" sound + anuswara
    reg1 = re.compile("([kKgGfcCjJFtTdDNwWxXnpPbBmyrlvSRsh])M")
    itran_string = reg1.sub("\g<1>aM", itran_string)

    return itran_string


pairs = [
    ( "అమ్మ", "amma"),
    ( "తల్లి" , "thalle"),
    ( "తండ్రి" , "thandre"),
    ( "నాన్న" , "naanna"),
    ( "అన్నయ్య" , "annayya")
]

# test_df = pd.DataFrame(pairs, columns=["Hindi String", "Actual WX"])
# test_df["Our WX"] = test_df["Hindi String"].apply(hin2wx)
# test_df["Both WX eq?"] = test_df["Actual WX"] == test_df["Our WX"]
# test_df.index = test_df.index + 1
# print(test_df)


test_df = pd.read_csv('iddari_shishyula_katha', sep="\n", header=None)
test_df.columns = ["Telugu String"]

tf = pd.DataFrame(columns=['Telugu String'])
for i,line in enumerate(test_df['Telugu String']):
  val = []
  arr = line.split()
  val = [telugu2itran(x) for x in arr]
  tf.loc[i] = " ".join(val)


import csv

txt_file = 'out.txt'
open(txt_file, 'w').close()
with open(txt_file, "w") as my_output_file:
        [ my_output_file.write(row+'\n') for row in tf['Telugu String']]
my_output_file.close()

