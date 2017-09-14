FactoryGirl.define do
  factory :business do
    # association :merchant, strategy: :build
    merchant

    name "Roga & Kopyta"
    zip_code "10010"
    city "New York"
    state "NY"
    address "128 E. State Street"
    phone "610-444-5566"

    trait :credentials do # fake credential data for tests
      access_token "2482262592-JFJU9FDtjCcmjQWUZAM0uMguj01sRTixxcSlysA"
      secret_token "Yq1fDPka2e5NSBbJRW4P4V7n0eRugHqFRBy897gCsjdd6"
      facebook_access_token "CAAVNtbiNrNoBABQVAQAL7zd9ZCBQPshNS7OL3UN1zZCY2C80CBrW2jlYCwr1DRHKKBbJR2eKxghUtjG1w29PvvzbQd8DuAj8wBgvr6Ew12B9BdutyhprwFP39cMeogIRA2aZAo7F4gbRzWkZCqIU9Sptg3RwUyYUx5wHhU4QuMGNVaZCjJsug"
      facebook_page_identifier "316685268479152"
      facebook_page_access_token "CAAVNtbiNrNoBAOCDAGQ46dL1ojU0CGoslKX08AVGydpZB14jv8N19uNreVF26ZCerv8ERUuIvXZBZA7ucq8F8GE4Ihetkjhn7KIZAQ1PCpisU0puzpp9v1nGKgpZA64gt66kDtG0QKV6ZChWJsxj8oEXOgasYtftSMxzswV7usuakzWWz0FU5SnXY0xVMiHd00ZD"
    end
  end
end
