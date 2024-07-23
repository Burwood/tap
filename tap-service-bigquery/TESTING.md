
## Testing Queries

Below are examples of testing with stilts.  Output is discarded.  To see output reomve omode flag.
`time java -jar stilts.jar tapquery sync=false tapurl="https://irsa.ipac.caltech.edu/TAP" adql="SELECT * FROM allwise_p3as_psd WHERE source_id='0000m031_ac51-054872'" omode=discard`

Example for testing with tap.burwood.io.
`time java -jar stilts.jar tapquery sync=false tapurl="http://tap.burwood.io/tap" adql="SELECT * FROM tapdata.allwise WHERE source_id='0000m031_ac51-054872'" omode=discard`