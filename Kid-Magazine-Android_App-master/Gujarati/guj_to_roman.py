import re
import sys
import random
import string

import pandas as pd

gujarati_vowels = [ "અ", "આ", "ઇ", "ઈ", "ઉ", "ઊ", "ઋ", "એ", "ઐ", "ઓ", "ઔ", "અં", "અઃ"]
gujarati_sonorants = ["ય", "ર", "લ", "વ"]
gujarati_anuswara = ["ં"]
gujarati_nukta = ["़"]
gujarati_consonants = [
    "ક", "ખ", "ગ", "ઘ", "ચ",
    "છ", "જ", "ઝ", "ટ", "ઠ",
    "ડ", "ઢ", "ણ", "ત", "થ",
    "દ", "ધ", "ન", "પ", "ફ",
    "બ", "ભ", "મ", "ય", "ર",
    "લ", "વ", "શ", "સ",
    "ષ", "હ", "ળ", "ક્ષ", "જ્ઞ",
]

gujarati2itran_vowels = {
    "અ": "a",
    "આ": "aa",
    "ઇ": "i",
    "ઈ": "ii",
    "ઉ": "u",
    "ઊ": "uu",
    "ઋ": "r",
    "એ": "e",
    "ઐ": "ai",
    "ઓ": "o",
    "ઔ": "au",
    "અં": "an",
    "અઃ": "ah",
    "ા": "aa",
    "િ": "i",
    "ી": "ii",
    "ુ": "u",
    "ૂ": "uu",
    "ે": "e",
    "ૈ": "ai",
    "ો": "o",
    "ૌ": "au",
    "ં": "an",
    "ઃ": "ah",
    "ૃ": "r",
    "ૅ": "e",
    "ૉ": "o",
    "્": "",

}
gujarati2itran_sonorants = {
    "ય": "ya",
    "ર": "ra",
    "લ": "la",
    "વ": "va",
}
gujarati2itran_anuswara = {"ં": "n", " ঁ": "n"}
gujarati2itran_consonants = {
    "ક": "k",
    "ખ": "kh",
    "ગ": "g",
    "ઘ": "gh",
    "ચ": "ch",
    "છ": "chh",
    "જ": "j",
    "ઝ": "jh",
    "ટ": "t",
    "ઠ": "th",
    "ડ": "d",
    "ઢ": "dh",
    "ણ": "n",
    "ત": "t",
    "થ": "th",
    "દ": "d",
    "ધ": "dh",
    "ન": "n",
    "પ": "p",
    "ફ": "ph",
    "બ": "b",
    "ભ": "bh",
    "મ": "m",
    "ય": "y",
    "ર": "r",
    "લ": "l",
    "વ": "v",
    "શ": "sh",
    "સ": "s",
    "ષ": "shh",
    "હ": "h",
    "ળ": "l",
    "ક્ષ": "ksh",
    "જ્ઞ": "gy",
    "ૐ": "om",
    "ૠ": "rr",
}

gujarati2itran_numbers = {
    "૦": "0",
    "૧": "1",
    "૨": "2",
    "૩": "3",
    "૪": "4",
    "૫": "5",
    "૬": "6",
    "૭": "7",
    "૮": "8",
    "૯": "9",
}
special_char= [".", "?", "!", "@", "%", "#", "~", "$", "^", "&", "*", "(", ")", "-", "_", "+", "=", "[","]", "{", "}", "\"", "\"", "\'", "|", "\\", ",", "/", ":", ";" ]

gujarati2itran_all = {
    **gujarati2itran_vowels, **gujarati2itran_anuswara,
    **gujarati2itran_sonorants, **gujarati2itran_consonants,
    **gujarati2itran_numbers,

}


def is_vowel_gujarati(char):
    """
    Checks if the character is a vowel.
    """
    if char in gujarati2itran_anuswara or char in gujarati2itran_vowels:
        return True
    return False


def gujarati2itran(gujarati_string):
    itran_string = []
    for i, current_char in enumerate(gujarati_string[:-1]):
        # skipping over the character as it's not included
        # in the mapping
        if current_char == "‍্" :
            continue
        if current_char== '"' or current_char=="'":
            itran_string.append(gujarati2itran_all[current_char])
            continue
        # get the Roman character for the Devanagari character
        if current_char in gujarati2itran_all:
            itran_string.append(gujarati2itran_all[current_char])
        else:
            itran_string.append(current_char)

        # Handling of "a" sound after a consonant if the next
        # character is not "्" which makes the previous character half

        if not is_vowel_gujarati(current_char):
            if gujarati_string[i + 1] != "‍্" and gujarati_string[i] not in special_char and gujarati_string[i]!='"' and not is_vowel_gujarati(gujarati_string[i + 1]):
                itran_string.append(gujarati2itran_all["અ"])
    if is_vowel_gujarati(gujarati_string[-1]):
        itran_string.append(gujarati2itran_all[gujarati_string[-1]])
    if not is_vowel_gujarati(gujarati_string[-1]):
        if gujarati_string[-1] in gujarati2itran_all:
            itran_string.append(gujarati2itran_all[gujarati_string[-1]])
            if gujarati_string[-1] not in gujarati2itran_numbers and gujarati_string[-1] not in special_char:
                itran_string.append(gujarati2itran_all["અ"])
        # else:
        #     itran_string.append(gujarati_string[-1])
            # itran_string.append(gujarati2itran_all[current_char])

    if gujarati_string[-1] not in gujarati2itran_all:
        itran_string.append(gujarati_string[-1])
    itran_string = "".join(itran_string)

    # consonant + anuswara should be replaced by
    # consonant + "a" sound + anuswara

    # reg1 = re.compile("([kKgGfcCjJFtTdDNwWxXnpPbBmyrlvSRsh])M")
    # itran_string = reg1.sub("\g<1>aM", itran_string)

    return itran_string

test_df = pd.read_csv('Gujarati_Input.txt', sep="\n", header=None)
test_df.columns = ["gujarati String"]

tf = pd.DataFrame(columns=['gujarati String'])
for i, line in enumerate(test_df['gujarati String']):
    val = []
    arr = line.split()
    val = [gujarati2itran(x) for x in arr]
    tf.loc[i] = " ".join(val)

import csv

txt_file = 'Gujarati_output.txt'
open(txt_file, 'w').close()
with open(txt_file, "w") as my_output_file:
    [my_output_file.write(row + '\n') for row in tf['gujarati String']]
my_output_file.close()
