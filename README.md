# PureScript Workshop for JSConf Medellín

## Lesson 1: Getting Started

1. Install psc-package and pulp

```bash
npm i -g psc-package pulp
```

2. Initialize the project

```bash
pulp --psc-package init
```

3. Build the project

```bash
pulp --psc-package run
```

4. Do your happy dance!

```bash
My first PureScript project 🕺
```

## Part 2: Resources and Creating a Bundle

### Resources

1. [PureScript by Example](https://leanpub.com/purescript/read) (Free eBook)
2. [Let's Build a Simon Game in PureScript](https://medium.com/@arecvlohe/lets-build-a-simon-game-in-purescript-pt-1-b9fa587a11dd)
3. [PureScript Cheatsheet](https://github.com/joshburgess/purescript-cheat-sheet)
### Bundle

1. Creat an `index.html` at the root of your directory

```bash
touch index.html
```

2. Add basic `html` markup

```html
<!DOCTYPE html>
<html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
  </head>

  <body>
    <script src='./output/app.js'></script>
  </body>

</html>
```

3. Run the server

```bash
pulp server
```

4. Do your happy dance!

```bash
My first PureScript app 💃
```
