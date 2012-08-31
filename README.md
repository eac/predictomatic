A Ruby playground for VW.

```bash
predictomatic [master]$ cd examples
examples [master]$ ruby forward_predictor.rb 
vw data/forward_dataset.tmp -c --passes 25 -f data/forward.model --quiet --ngram 2 -b 22
You have chosen to generate 2-grams
vw -i data/forward.model -t /dev/stdin -p /dev/stdout --quiet
[{:label=>"yes", :value=>1.0}, {:label=>"no", :value=>0.355721}, {:label=>"no_too_much", :value=>0.2446}]
Predicted in 0.00998 seconds
```

Interesting things to consider supporting:

https://github.com/JohnLangford/vowpal_wabbit/wiki/Matrix-factorization-example
https://github.com/JohnLangford/vowpal_wabbit/wiki/Latent-Dirichlet-Allocation
