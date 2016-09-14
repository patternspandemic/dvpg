let project = new Project('Delaunay Voronoi Playground');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary('thx.core');
project.addLibrary('edge');
project.addLibrary('hxDelaunay');
project.addLibrary('zui');
resolve(project);
