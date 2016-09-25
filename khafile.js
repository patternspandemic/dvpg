let project = new Project('Delaunay Voronoi Playground');
project.addAssets('Assets/**');

project.addSources('Sources');
project.addSources('Libraries/hxDelaunay/src');

project.addLibrary('polygonal-ds');
project.addLibrary('ecx');
project.addLibrary('ecx_common');
project.addLibrary('zui');

resolve(project);
