let project = new Project('Delaunay Voronoi Playground');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addSources('Libraries/hxDelaunay/src');
// project.addLibrary('hxDelaunay');
project.addLibrary('thx.core');
project.addLibrary('edge');
project.addLibrary('zui');
resolve(project);
