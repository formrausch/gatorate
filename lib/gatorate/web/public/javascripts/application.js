function stopScrolling( touchEvent ) { touchEvent.preventDefault(); }
document.addEventListener( 'touchstart' , stopScrolling , false );
document.addEventListener( 'touchmove' , stopScrolling , false );

$(function() {
  var door = {
    closed: function(){
      $('.e').removeClass('s0').removeClass('s2').addClass('s1')
    },
    open: function(){
      $('.e').removeClass('s0').removeClass('s1').addClass('s2')
    }    
  }

  !(function check_status() {
    $.getJSON('/status', function(data){
      door[data.status]()
      setTimeout(check_status, 1000)
    })
  })()
  
  // function reorient(e) {
  //   var portrait = (window.orientation % 180 == 0);
  //   $("body > div").css("-webkit-transform", !portrait ? "rotate(-90deg)" : "");
  // }
  // window.onorientationchange = reorient;
  // window.setTimeout(reorient, 0);
  
})

      // Listen for resize changes
// window.addEventListener("orientationchange", function() { 
//     if( window.orientation == -90 ) {
//         document.getElementById('orient').className = 'orientright'
//     }
//     if( window.orientation == 90 ) {
//         document.getElementById('orient').className = 'orientleft'
//     }
//     if( window.orientation == 0 ) {
//         document.getElementById('orient').className = ''
//     }
//  }, true);

