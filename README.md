# File-Integrity-Monitoring
File Integrity Monitoring application created with PowerShell.

Detects when a file in the files folder has been modified, deleted or created using hash values.

1. collect baseline
   Store the file path and the corresponding hash value in a Baseline.txt file.

2. Monitoring Files 
   Check if new hash values have been added, if they still match or are missing from the hash values previously stored in Baseline.txt.

   Change the files in the Files folder and check with "Monitoring once" if there were changes in the files.
   Select "Monitoring certain time", specify the desired time in which the files in the Files folder should be monitored and change the files in this time period to        trigger the messages.
   
  
   Example:
   
   Changing the contents of the A.txt file will trigger the following message:   C:\path\to\FIM\Files\A.txt has changed!
   
   Deleting the A.txt file will trigger the following message: C:\path\to\FIM\Files\A.txt has been deleted!
   
   The creation of the new D.txt file will trigger the following message: C:\path\to\FIM\Files\D.txt has been created!
