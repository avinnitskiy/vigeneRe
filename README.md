# vigeneRe
An R function to generate original and extended Vigenère cipher tables for secure physical use.

This project provides an R function for generating printable Vigenère cipher tables in various character encodings. It is intended for secure **physical** password protection, enabling manual encryption and decryption without reliance on digital tools or software.

## 1. Issue

Modern cryptography has developed a robust and conventional approach to securely storing passwords — through the use of hash functions (e.g., SHA-256) applied to a master key. While such algorithms are irreversible and highly resistant to brute-force attacks or direct access, they still become vulnerable when used on computers. 

An attacker only needs access to a user's clipboard, keyboard input, or screen (via malicious software) to compromise the master key — which would grant access to all other passwords. In such a scenario, no amount of entropy from a complex character set can provide protection.

For this reason, it may make sense to store some of your most crucial passwords **physically**, detached from any local or cloud-based digital access. However, keeping passwords physically in plain text also carries significant risks:

- You might lose them while outside your home, allowing anyone who finds them to access your services;
- Someone could break into your home and accidentally or intentionally find your passwords.

Yet using hash functions for physical storage becomes impractical without access to scripts or a computer. In such cases, **symmetric encryption** becomes a viable alternative — considered insecure for online use but ideal for offline physical storage, where a **memorized master key** replaces the use of hashing. One of the most practical algorithms for this purpose is the **Vigenère cipher**.

While the original Vigenère table — consisting of 26 uppercase Latin letters — is widely available online, **extended versions** using ASCII or Base encodings are much harder to find. And almost never are such extended tables implemented in the **R programming language**.

## 2. Solution

### 2.1 Function and Arguments

To address this gap, this project introduces a simple function written in **R** — `generate_vigenere_table()` — which builds Vigenère cipher tables in various encodings and formats. The goal is to allow for **secure offline encryption/decryption** using printed tables.

```r
generate_vigenere_table(
  output = "dataframe",
  filename = NULL,
  type = "original",
  encoding_standard = NULL
)
```

It can take 4 arguments:

- **type** (`character`): choose between `"original"` and `"extended"`:
  - `"original"` — generates the traditional 26×26 Vigenère table using only uppercase English letters (A–Z);
  - `"extended"` — generates a table using a broader character set, defined by the `encoding_standard` argument.

- **encoding_standard** (`character`): required only if `type = "extended"`. Specifies which character set to use. Possible values:  
  - `"ASCII95"` — all printable ASCII characters from code 32 (space) to 126 (`~`), total of 95;
  - `"ASCII92"` — same as ASCII95, but excluding `"`, `'`, and `\`, total of 92;
  - `"ASCII91"` — same as ASCII92, but also excludes space character, total of 91;  
  - `"Base64"` — standard Base64 character set (`A–Z`, `a–z`, `0–9`, `+`, `/`);
  - `"Base58"` — Base58 character set used in crypto, excludes `0`, `O`, `I`, `l`, `+`, `/` for better readability.

- **output** (`character`): defines the output format of the Vigenère table. Possible values:  
  - `"dataframe"` — returns the table as an R data.frame in the console. It can be stored as a variable object;
  - `"csv"` — saves the table as a CSV file;
  - `"pdf"` — saves the table as a printable PDF. Automatically adjusts paper size (A1 to A4) based on table size.

- **filename** (`character`, optional): optional filename to save the output when using `"csv"` or `"pdf"` output types. If not provided (`NULL`), defaults to `"vigenere_table.csv"` or `"vigenere_table.pdf"` depending on the format.

### 2.2 Example

```r
df <- generate_vigenere_table(output = "dataframe", type = "original") # stores original Vigenère table as an R dataframe

generate_vigenere_table(output = "pdf", type = "extended", encoding_standard = "Base58") # saves Base58 version of table into .pdf
```

**Attention!** This function intentionally does not perform actual encryption or decryption for you. Its sole purpose is to generate printable Vigenère cipher tables in various encodings, for manual use. If you're looking for ready-to-use symmetric encryption/decryption Vigenère functions, those are widely available in R and other programming languages. This function deliberately avoids including encryption logic to eliminate the risk of digital compromise (e.g., via clipboard sniffers, keyloggers, or screen recorders). If this risk weren’t present, there would be no strong reason to favor less secure symmetric encryption over hashed password storage in password managers.


