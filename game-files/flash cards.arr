use context starter2024
include tables


vocab-cs = [table-from-columns:
  {"word"; [list: "abstraction", "algorithm"]},
  {"definition"; [list: "sdfdsfsdfsdf", "sdfdsfsdfsdf"]},
  {"def-with-breaks"; [list:"ghnhjnjkgh ", "gdfh jnghfg"]}
  ]


data FlashCard:
    fc(term  :: String,
      def    :: String,
      reveal :: Boolean,
      size   :: Number
      ) with:
    method display(self):
      0
    end
end
  

fun show-card(msg, color, size):
  0
end
    


