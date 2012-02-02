$perceptStrategy("geo_object" , function(percepts){
  onPercept(percepts);
});

$perceptStrategy("geo_agent" , function(percepts){
  // do nothing
});

$perceptStrategy("edges" , function(percepts){
  onEdgesPercept(percepts);
});

$perceptStrategy("posts_read" , function(percepts){
  onPostsReadPercept(percepts);
});