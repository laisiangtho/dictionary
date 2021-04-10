# Type and models

connection

```shell
word -> { w: wordId, v: string }
sense -> { i: uId, w: wordId, t: 0, v: string }
usage -> { i: uId, v: string }
```

List of ResultModel

```json
result = [
  {
    word:'',
    sense:[
      {
        pos:'',
        clue:[
          {
            mean:''
            exam:['','']
          }
        ]
      }
    ]
  }
]
```
