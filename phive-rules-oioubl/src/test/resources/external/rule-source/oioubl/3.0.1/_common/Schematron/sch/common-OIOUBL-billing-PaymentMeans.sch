<pattern
        xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

        <title>OIOUBL 3 - PaymentMeans</title>

        <title>PaymentMeans 31 - Main</title>


        <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '1']">

                <assert
                        id="OIOUBL-BIL-124"
                        test="not(cbc:PaymentChannelCode)"
                        flag="fatal">PaymentChannelCode is not allow when the
                        PaymentMeans = 1</assert>

        </rule>


        <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '10']">

                <assert
                        id="OIOUBL-BIL-125"
                        test="not(cbc:PaymentChannelCode)"
                        flag="fatal">PaymentChannelCode is not allow when the
                        PaymentMeans = 10</assert>

        </rule>



        <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '31']">

                <assert
                        id="OIOUBL-BIL-028"
                        test="not(cbc:InstructionNote)"
                        flag="fatal">InstructionNote is not allow when the PaymentMeansCode = '31'</assert>

                <assert
                        id="OIOUBL-BIL-029"
                        test="cac:PayeeFinancialAccount/cbc:ID"
                        flag="fatal">PayeeFinancialAccount/ID is mandatory when the PaymentMeansCode = '31'</assert>

                <assert
                        id="OIOUBL-BIL-030"
                        test="string-length(cac:PayerFinancialAccount/cbc:PaymentNote) &lt;= 20"
                        flag="fatal">PaymentNote must not be more than 20 characters when the
                        PaymentMeansCode = '31' - Value found: '<value-of
                                select="cac:PayerFinancialAccount/cbc:PaymentNote"/>' </assert>

                <assert
                        id="OIOUBL-BIL-091"
                        test="string-length(cac:PayeeFinancialAccount/cbc:PaymentNote) &lt;= 20"
                        flag="fatal">PaymentNote must not be more than 20 characters when the
                        PaymentMeansCode = '31' - Value found: '<value-of
                                select="cac:PayeeFinancialAccount/cbc:PaymentNote"/>' </assert>

                <assert
                        id="OIOUBL-BIL-031"
                        test="string-length(cac:CreditAccount/cbc:AccountID) &lt;= 8"
                        flag="fatal">If PaymentMeansCode = 31 CreditAccount/AccountID must not be
                        more than 8 characters - Value found: '<value-of
                                select="cbc:AccountID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-024"
                        test="cbc:PaymentChannelCode != 'IBAN' or (string-length(cac:PayeeFinancialAccount/cbc:ID) &lt;= 34)"
                        flag="fatal">If PaymentMeansCode = 31 and PaymentChannelCode is 'IBAN', then PayeeFinancialAccount/ID must not
                        be more than 34 digits - Value found: '<value-of
                                select="cac:PayeeFinancialAccount/cbc:ID"/>' </assert>       

                <assert
                        id="OIOUBL-BIL-025"
                        test="not(cbc:PaymentChannelCode = 'ZZZ') or cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"
                        flag="fatal">PaymentMeansCode = 31 then FinancialInstitutionBranch/ID is mandatory when PaymentChannelCode equals 'ZZZ'
                </assert>

                <assert
                        id="OIOUBL-BIL-026"
                        test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name"
                        flag="fatal">If PaymentMeansCode = 31 then FinancialInstitutionBranch/Name
                        element is mandatory </assert>

                <assert
                        id="OIOUBL-BIL-027"
                        test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address"
                        flag="fatal">If PaymentMeansCode = 31 then
                        FinancialInstitutionBranch/Address class is mandatory </assert>


                <assert
                        id="OIOUBL-BIL-095"
                        test="cbc:PaymentChannelCode != 'IBAN' or (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) != '')"
                        flag="fatal">When PaymentMeansCode = 31 and PaymentChannelCode is 'IBAN', the ID element in PayeeFinancialAccount/FinancialInstitutionBranch/FinancialInstitution/ must be used</assert>

                <assert

                        id="OIOUBL-BIL-120"
                        test="cbc:PaymentChannelCode"
                        flag="fatal">When PaymentMeansCode is = 31, then PaymentChannelCode is mandatory</assert>

                <assert
                        id="OIOUBL-BIL-121"
                        test="cbc:PaymentChannelCode = 'IBAN' or cbc:PaymentChannelCode = 'ZZZ'"
                        flag="fatal">When PaymentMeansCode = 31, then PaymentChannelCode should be either 'IBAN' or 'ZZZ' - Value found: '<value-of
                                select="cbc:PaymentChannelCode"/>'</assert>

        </rule>



        <title>PaymentMeans 42 - Main</title>

        <rule
                context="cac:PaymentMeans[cbc:PaymentMeansCode = '42']">


                <assert
                        id="OIOUBL-BIL-113"
                        test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:BANK'"
                        flag="fatal">If PaymentChannelCode is present, its value must be 'DK:BANK' when PaymentMeansCode is '42' - Value found = '<value-of
                                select="cbc:PaymentChannelCode"/>'</assert>

                <assert
                        id="OIOUBL-BIL-033"
                        test="not(cac:CreditAccount)"
                        flag="fatal">CreditAccount is not allow when the PaymentMeans = '42'</assert>

                <assert
                        id="OIOUBL-BIL-034"
                        test="not(cbc:InstructionNote)"
                        flag="fatal">InstructionNote is not allow when the PaymentMeans = '42'</assert>

                <assert
                        id="OIOUBL-BIL-035"
                        test="string-length(cac:PayerFinancialAccount/cbc:PaymentNote) &lt;= 20"
                        flag="fatal">PaymentNote must not be more than 20 characters when
                        PaymentMeansCode = '42' - Value found: '<value-of
                                select="cac:PayerFinancialAccount/cbc:PaymentNote"/>' </assert>

                <assert
                        id="OIOUBL-BIL-092"
                        test="string-length(cac:PayeeFinancialAccount/cbc:PaymentNote) &lt;= 20"
                        flag="fatal">PaymentNote must not be more than 20 characters when
                        PaymentMeansCode = '42' - Value found: '<value-of
                                select="cac:PayeeFinancialAccount/cbc:PaymentNote"/>' </assert>

                <assert
                        id="OIOUBL-BIL-037"
                        test="cac:PayeeFinancialAccount"
                        flag="fatal">PayeeFinancialAccount is mandatory when the PaymentMeans = '42'</assert>


                <assert
                        id="OIOUBL-BIL-038"
                        test="cac:PayeeFinancialAccount/cbc:ID"
                        flag="fatal">PayeeFinancialAccount/ID is mandatory when the PaymentMeans = '42'</assert>

                <assert
                        id="OIOUBL-BIL-039"
                        test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID and matches(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID, '^\d{4}$')"
                        flag="fatal">PayeeFinancialAccount/FinancialInstitutionBranch/ID must exist
                        and be 4 digits long when PaymentMeansCode = '42' - Value found: '<value-of
                                select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-040"
                        test="string-length(cac:PayeeFinancialAccount/cbc:ID) &lt;= 10"
                        flag="fatal">PayeeFinancialAccount/ID must not be more than 10 characters when PaymentMeansCode = '42' -
                        Value found: '<value-of
                                select="cac:PayeeFinancialAccount/cbc:ID"/>' </assert>

        </rule>



        <title>PaymentMeans 48 - Main</title>

        <rule
                context="cac:PaymentMeans[cbc:PaymentMeansCode = '48']">

                <assert
                        id="OIOUBL-BIL-032"
                        test="not(cbc:PaymentChannelCode)"
                        flag="fatal">PaymentChannelCode is not allow when the
                        PaymentMeans = 48</assert>

                <assert
                        id="OIOUBL-BIL-041"
                        test="not(cbc:InstructionID)"
                        flag="fatal">InstructionID is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-042"
                        test="not(cbc:InstructionNote)"
                        flag="fatal">InstructionNote is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-043"
                        test="not(cac:PayerFinancialAccount)"
                        flag="fatal">PayerFinancialAccount is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-044"
                        test="not(cac:PayeeFinancialAccount)"
                        flag="fatal">PayeeFinancialAccount is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-045"
                        test="not(cac:CreditAccount)"
                        flag="fatal">CreditAccount is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-046"
                        test="cac:CardAccount"
                        flag="fatal">CardAccount must be used when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-047"
                        test="not(cac:CardAccount/cbc:CardTypeCode)"
                        flag="fatal">CardAccount/CardTypeCode is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-048"
                        test="not(cac:CardAccount/cbc:ValidityStartDate)"
                        flag="fatal">CardAccount/ValidityStartDate is not allow when the
                        PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-049"
                        test="not(cac:CardAccount/cbc:ExpiryDate)"
                        flag="fatal">CardAccount/ExpiryDate is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-050"
                        test="not(cac:CardAccount/cbc:IssuerID)"
                        flag="fatal">CardAccount/IssuerID is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-051"
                        test="not(cac:CardAccount/cbc:IssueNumberID)"
                        flag="fatal">CardAccount/IssueNumberID is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-052"
                        test="not(cac:CardAccount/cbc:CV2ID)"
                        flag="fatal">CardAccount/CV2ID is not allow when the PaymentMeans = '48'></assert>

                <assert
                        id="OIOUBL-BIL-053"
                        test="not(cac:CardAccount/cbc:CardChipCode)"
                        flag="fatal">CardAccount/CardChipCode is not allow when the PaymentMeans = '48'</assert>

                <assert
                        id="OIOUBL-BIL-054"
                        test="not(cac:CardAccount/cbc:ChipApplicationID)"
                        flag="fatal">CardAccount/ChipApplicationID is not allow when the
                        PaymentMeans = '48'</assert>

        </rule>


        <title>PaymentMeans 49 - Main</title>

        <rule
                context="cac:PaymentMeans[cbc:PaymentMeansCode = '49']">

                <assert
                        id="OIOUBL-BIL-122"
                        test="cbc:PaymentChannelCode"
                        flag="fatal">When PaymentMeansCode = 49 then PaymentChannelCode is mandatory</assert>

                <assert
                        id="OIOUBL-BIL-123"
                        test="cbc:PaymentChannelCode = 'DK:BANK' or cbc:PaymentChannelCode = 'IBAN'"
                        flag="fatal">When PaymentMeansCode = 49 then PaymentChannelCode should be either 'DK:BANK' or 'IBAN' - Value found: '<value-of
                                select="cbc:PaymentChannelCode"/>'</assert>

                <assert
                        id="OIOUBL-BIL-055"
                        test="not(cbc:InstructionNote)"
                        flag="fatal">InstructionNote is not allow when the PaymentMeans = '49'/></assert>

                <assert
                        id="OIOUBL-BIL-056"
                        test="not(cac:CreditAccount)"
                        flag="fatal">CreditAccount is not allowed when the PaymentMeans = '49'/></assert>

                <assert
                        id="OIOUBL-BIL-057"
                        test="cbc:InstructionID"
                        flag="fatal">InstructionID is mandatory when PaymentMeans = '49'"/>
                </assert>

                <assert
                        id="OIOUBL-BIL-058"
                        test="string-length(cac:PayerFinancialAccount/cbc:PaymentNote) &lt;= 20"
                        flag="fatal">PaymentNote must not be more than 20 characters when
                        PaymentMeansCode = '49' - Value found: '<value-of
                                select="cac:PayerFinancialAccount/cbc:PaymentNote"/>' </assert>

                <assert
                        id="OIOUBL-BIL-059"
                        test="string-length(cbc:InstructionID) &lt;= 60"
                        flag="fatal">InstructionID must not be more than 60 characters when
                        PaymentMeansCode = '49' - Value found: '<value-of
                                select="cbc:InstructionID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-060"
                        test="not(cbc:PaymentChannelCode='DK:BANK')
                        or (cac:PaymentMandate/cbc:ID and cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)"
                        flag="fatal">PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when PaymentMeansCode is '49' and PaymentChannelCode is 'DK:BANK' - Value found:  '<value-of
                                                select="cac:PayerFinancialAccount/cbc:ID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-061"
                        test="not(cbc:PaymentChannelCode = 'DK:BANK') or string-length(cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 4"
                        flag="fatal">If cbc:PaymentChannelCode is 'DK:BANK', then PaymentMandate/PayeeFinancialAccount/FinancialInstitutionBranch/ID must be 4 characters when
                        PaymentMeansCode = '49' - Value found:'<value-of
                                select="cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-062"
                        test="not(cbc:PaymentChannelCode = 'IBAN') or (string-length(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID) &gt;= 18 and string-length(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID) &lt;= 34)"
                        flag="fatal">If PaymentChannelCode = 'IBAN' then PaymentMandate/ayerFinancialAccount/ID must be between 18 and 34 characters
                        when PaymentMeansCode = '49' - Value found: '<value-of
                                select="cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-063"
                        test="not(cbc:PaymentChannelCode = 'IBAN') or (not(cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID))"
                        flag="fatal">If PaymentChannelCode = 'IBAN' then PaymentMandate/PayerFinancialAccount/FinancialInstitutionBranch/ID is not
                        allowed when PaymentMeansCode = '49'"/></assert>

                <assert
                        id="OIOUBL-BIL-064"
                        test="not(cbc:PaymentChannelCode = 'IBAN') or (cac:PaymentMandate/cac:PayerFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID)"
                        flag="fatal">If PaymentChannelCode = 'IBAN' then PaymentMandate/PayerFinancialAccount/FinancialInstitutionBranch/FinancialInstitution/ID
                        must be present when PaymentMeansCode = '49'"/></assert>

        </rule>


        <title>PaymentMeans 50 - Main</title>

        <rule
                context="cac:PaymentMeans[cbc:PaymentMeansCode = '50']">

                <assert
                        id="OIOUBL-BIL-114"
                        test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:GIRO'"
                        flag="fatal">If PaymentChannelCode is present, its value must be 'DK:GIRO' when PaymentMeansCode is '50' - Value found = '<value-of
                                select="cbc:PaymentChannelCode"/>'</assert>

                <assert
                        id="OIOUBL-BIL-065"
                        test="not(cac:CreditAccount)"
                        flag="fatal">CreditAccount is not allowed when the PaymentMeans = '50'</assert>

                <assert
                        id="OIOUBL-BIL-066"
                        test="cbc:PaymentID"
                        flag="fatal">PaymentID must be present when PaymentMeansCode ='50'</assert>

                <assert
                        id="OIOUBL-BIL-067"
                        test="cac:PayeeFinancialAccount/cbc:ID"
                        flag="fatal">PayeeFinancialAccount/ID must be present when PaymentMeansCode
                        = '50'</assert>

                <assert
                        id="OIOUBL-BIL-068"
                        test="not(cbc:PaymentID = ('04', '15')) or cbc:InstructionID"
                        flag="fatal">InstructionID is mandatory when PaymentID equals 04 or 15 and
                        PaymentMeansCode = '50'</assert>

                <assert
                        id="OIOUBL-BIL-069"
                        test="not(cbc:PaymentMeansCode) or cbc:PaymentID = ('01', '04', '15')"
                        flag="fatal">PaymentID must equal 01, 04 or 15 when PaymentMeansCode = '50'</assert>

                <assert
                        id="OIOUBL-BIL-070"
                        test="not(cbc:InstructionNote) or (cbc:PaymentID = '01')"
                        flag="fatal">InstructionNote is only allowed if PaymentID equals 01 when
                        PaymentMeansCode = '50'</assert>

                <assert
                        id="OIOUBL-BIL-072"
                        test="string-length(cbc:InstructionID) &lt;= 16"
                        flag="fatal">InstructionID must be 18 or less characters when
                        PaymentMeansCode = '50'- Value found: '<value-of
                                select="cbc:InstructionID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-073"
                        test="not(cbc:PaymentID = ('04', '15')) and cbc:PaymentMeansCode = '50' or matches(cbc:InstructionID, '^\d+$')"
                        flag="fatal">InstructionID must be numeric when PaymentID = '04' or '15' and
                        PaymentMeansCode = '50' - Value found: '<value-of
                                select="cbc:InstructionID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-074"
                        test="
                                not(cbc:PaymentMeansCode = '50')
                                or matches(cac:PayeeFinancialAccount/cbc:ID, '^[0-9]{7,8}$')"
                        flag="fatal">PayeeFinancialAccount/ID must consist of 7 or 8 numerical
                        characters when PaymentMeansCode = '50' - Value found: '<value-of
                                select="cac:PayeeFinancialAccount/cbc:ID"/>' </assert>

        </rule>



        <title>PaymentMeans 58 - Main</title>

        <rule
                context="cac:PaymentMeans[cbc:PaymentMeansCode = '58']">

                <assert
                        id="OIOUBL-BIL-094"
                        test="not(cbc:PaymentChannelCode)"
                        flag="fatal">PaymentChannelCode is not allow when the
                        PaymentMeans = 58'</assert>

                <assert
                        id="OIOUBL-BIL-075"
                        test="cac:PayeeFinancialAccount/cbc:ID"
                        flag="fatal">PayeeFinancialAccount/ID must be present when PaymentMeansCode
                        = '58'</assert>

        </rule>


        <title>PaymentMeans 59 - Main</title>

        <rule context="cac:PaymentMeans[cbc:PaymentMeansCode = '59']">

                <assert
                        id="OIOUBL-BIL-126"
                        test="not(cbc:PaymentChannelCode)"
                        flag="fatal">PaymentChannelCode is not allow when the
                        PaymentMeans = 59</assert>

        </rule>


        <title>PaymentMeans 93 - Main</title>

        <rule
                context="cac:PaymentMeans[cbc:PaymentMeansCode = '93']">

                <assert
                        id="OIOUBL-BIL-115"
                        test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:FIK'"
                        flag="fatal">If PaymentChannelCode is present, its value must be 'DK:FIK' when PaymentMeansCode is '93' - Value found = '<value-of
                                select="cbc:PaymentChannelCode"/>'</assert>

                <assert
                        id="OIOUBL-BIL-076"
                        test="cbc:PaymentID"
                        flag="fatal">PaymentID must be present when PaymentMeansCode = '93'</assert>


                <assert
                        id="OIOUBL-BIL-077"
                        test="not(cbc:PaymentID = '71' or cbc:PaymentID = '75') or cbc:InstructionID"
                        flag="fatal">InstructionID is mandatory when PaymentID equals 71 or 75 and
                        PaymentMeansCode = '93'</assert>

                <assert
                        id="OIOUBL-BIL-078"
                        test="not(cbc:InstructionNote) or (cbc:PaymentID = '73' or cbc:PaymentID = '75')"
                        flag="fatal">InstructionNote is only allowed when PaymentID equals 73 or 75
                        and PaymentMeansCode = '93'</assert>

                <assert
                        id="OIOUBL-BIL-079"
                        test="cbc:PaymentID = ('71', '73', '75')"
                        flag="fatal">PaymentID must equal 71, 73 or 75 when PaymentMeansCode = '93' - Value found: '<value-of
                                select="cbc:PaymentID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-080"
                        test="not(cbc:PaymentID = '71') or string-length(cbc:InstructionID) = 15"
                        flag="fatal">InstructionID must equal 15 characters when PaymentID equals 71
                        and PaymentMeansCode = '93' - Value found: '<value-of
                                select="cbc:InstructionID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-081"
                        test="not(cbc:PaymentID = '75') or string-length(cbc:InstructionID) = 16"
                        flag="fatal">InstructionID must equal 16 characters when PaymentID equals 75
                        and PaymentMeansCode = '93' - Value found: '<value-of
                                select="cbc:InstructionID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-082"
                        test="not(cbc:PaymentID = ('71', '75')) or matches(cbc:InstructionID, '^[0-9]+$')"
                        flag="fatal">InstructionID must be a numeric value when PaymentID equals 71
                        or 75 and PaymentMeansCode = '93' - Value found: '<value-of
                                select="cbc:InstructionID"/>' </assert>

                <assert
                        id="OIOUBL-BIL-083"
                        test="not(cbc:InstructionID) or (cbc:PaymentID = '71' or cbc:PaymentID = '75')"
                        flag="fatal">InstructionID only allowed if PaymentID equals 71 or 75 when
                        PaymentMeansCode = '93'"/></assert>

                <assert
                        id="OIOUBL-BIL-084"
                        test="string-length(cac:CreditAccount/cbc:AccountID) = 8"
                        flag="fatal">CreditAccount/AccountID must be 8 characters when
                        PaymentMeansCode = '93' - Value found: '<value-of
                                select="cac:CreditAccount/cbc:AccountID"/>' </assert>

        </rule>



        <title>PaymentMeans 97 - Main</title>

        <rule
                context="cac:PaymentMeans[cbc:PaymentMeansCode = '97']">

                <assert
                        id="OIOUBL-BIL-116"
                        test="not(cbc:PaymentChannelCode) or cbc:PaymentChannelCode = 'DK:NEMKONTO'"
                        flag="fatal">If PaymentChannelCode is present, its value must be 'DK:NEMKONTO' when PaymentMeansCode is '97' - Value found = '<value-of
                                select="cbc:PaymentChannelCode"/>'</assert>

                <assert
                        id="OIOUBL-BIL-085"
                        test="not(cbc:InstructionID)"
                        flag="fatal">InstructionID is not allowed when PaymentMeansCode = '97'</assert>

                <assert
                        id="OIOUBL-BIL-086"
                        test="not(cbc:InstructionNote)"
                        flag="fatal">InstructionNote is not allowed when PaymentMeansCode = '97'></assert>

                <assert
                        id="OIOUBL-BIL-087"
                        test="not(cbc:PaymentID)"
                        flag="fatal">PaymentID is not allowed when PaymentMeansCode = '97'</assert>

                <assert
                        id="OIOUBL-BIL-088"
                        test="not(cac:PayerFinancialAccount)"
                        flag="fatal">PayerFinancialAccount is not allowed when PaymentMeansCode = '97'></assert>

                <assert
                        id="OIOUBL-BIL-089"
                        test="not(cac:PayeeFinancialAccount)"
                        flag="fatal">PayeeFinancialAccount is not allowed when PaymentMeansCode = '97'</assert>

                <assert
                        id="OIOUBL-BIL-090"
                        test="not(cac:CreditAccount)"
                        flag="fatal">CreditAccount is not allowed when PaymentMeansCode = '97'</assert>

        </rule>



        <title>PaymentTearm</title>

        <rule
                context="cac:PaymentTerms">

                <assert
                        id="OIOUBL-BIL-096"
                        test="not(cbc:ID = 'Factoring') or cbc:Note"
                        flag="fatal">When ID equals 'Factoring', Note element is mandatory
                        (factoring note)</assert>

                <assert
                        id="OIOUBL-BIL-097"
                        test="count(cbc:Note) &lt;= 1"
                        flag="fatal">No more than one Note element may be present</assert>


        </rule>
</pattern>
