window.onload = function(){
  var body = document.body;
  var data = document.getElementById("data");
  function Pair(w, n){
    this.w = w;
    this.n = n;
  };
  var getData = function(){
    if (data){
      var arr = data.dataset["list"].split(","); 
      var acc = [];
      for (var i = 0; i < arr.length; i++){
        (i % 2 === 0) ? acc.push(new Pair(arr[i], arr[i + 1])) : acc = acc;
      }
      console.log(acc);
    } else {
      return;
    }
  };
  getData();
}
