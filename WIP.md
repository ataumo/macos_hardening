# TODO

- Convert bash file to python to improve developpement and contributions 
- Define CSV convention to read and set policies 
- Check if this repo could be usefull : https://github.com/ProfileCreator/ProfileManifests/blob/master/Manifests/ManagedPreferencesApple/com.apple.GlobalPreferences.plist
- Implement a scrapper for macos cis benchmark (tested repo : https://github.com/aws-samples/cis-benchmark-pdf-parser; Hardening box is more efficient bcz can keep vategory for example)
    - Remove all useless strings 
        - "Page XX" 
            -regex : "Page \d+"
        - "Internal Only - General"
    - Split text content by recommendations 
        - Find the exact regex that give the exact number of recommentations
        - regex : (\d+(?:\.\d.\d*)+)(.*?)(\(Automated\)|\(Manual\))
        - remove all content before the first reco