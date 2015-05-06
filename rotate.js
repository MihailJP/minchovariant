function setRotated(poly, rad, index, baseX, baseY, offsetX, offsetY) {
	var r     = Math.sqrt(offsetX * offsetX + offsetY * offsetY);
	var theta = Math.atan2(offsetY, offsetX) + rad;
	var x     = r * Math.cos(theta);
	var y     = r * Math.sin(theta);
	poly.set(index, baseX + x, baseY + y);
}

function pushRotated(poly, rad, baseX, baseY, offsetX, offsetY) {
	var r     = Math.sqrt(offsetX * offsetX + offsetY * offsetY);
	var theta = Math.atan2(offsetY, offsetX) + rad;
	var x     = r * Math.cos(theta);
	var y     = r * Math.sin(theta);
	poly.push(baseX + x, baseY + y);
}
