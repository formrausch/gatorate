$(function() {
  var door = {
    closed: function(){
      $('.e').removeClass('s2').addClass('s1')
    },
    open: function(){
      $('.e').removeClass('s1').addClass('s2')
    }    
  }

  !(function check_status() {
    $.getJSON('/status', function(data){
      door[data.status]()
      setTimeout(check_status, 1000)
    })
  })()
})