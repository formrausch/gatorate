Ember.LOG_BINDINGS = true

App = Ember.Application.create({
  LOG_TRANSITIONS: true
})

App.Store = DS.Store.extend({
  revision: 12
});

App.Post = DS.Model.extend({
  title: DS.attr('string'),
  slug: DS.attr('string'),
  content: DS.attr('string'),
  excerpt: DS.attr('string'),
  publishDate: DS.attr('date'),
  isPublished: DS.attr('boolean')
});


App.Router.map(function() {
  this.resource('posts', function() {
    this.route('new');
    this.route('post', { path: '/:post_id' });
   });
});

App.IndexRoute = Ember.Route.extend({
  model: function() {
    return ['red', 'yellow', 'blue'];
  }
});

App.PostsIndexRoute = Em.Route.extend({
  setupController: function(controller, posts) {
    controller.set('content', posts);
  }
});


