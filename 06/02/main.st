f := FileStream open: './input.txt' mode: FileStream read.

pos := Dictionary new.

f linesDo: [ :l | 
    i := 0.
    l do: [ :c |
        d := Dictionary new.
        pos at: i ifAbsentPut: [d].

        d := pos at: i.
        d at: c ifPresent: [ :v |
            d at: c put: (v + 1)
        ].
        d at: c ifAbsentPut: [1].
        

        i :=  (Number coerce: i) + 1.
    ]
].

pos keys asSortedCollection collect: [:k |
    min := 1000.
    v := pos at: k.
    v keysAndValuesDo: [:c :i |
        min := min min: i.
    ].
    c := v keyAtValue: min.
   
   Transcript show: (c asString).   
].