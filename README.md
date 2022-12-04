# File-Integrity-Monitoring
File Integrity Monitoring application created with PowerShell.

Detects when a file in the files folder has been modified, deleted or created using hash values.

1. collect baseline
   Store the file path and the corresponding hash value in a Baseline.txt file.

2. Monitoring Files 
   Check if new hash values have been added, if they still match or are missing from the hash values previously stored in Baseline.txt.
