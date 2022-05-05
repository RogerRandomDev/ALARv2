shader_type canvas_item;

void fragment() {
	float closest=32.;
	for(float x=-4.;x<4.;x++){for(float y=-4.;y<4.;y++){
		float col=texture(TEXTURE,UV+vec2(x,y)*TEXTURE_PIXEL_SIZE).a;
		if(col>=1.){
			closest=min(closest,(pow(x,2.)+pow(y,2.))/col);
		}
	}}
	COLOR.a=closest/32. -0.03125;
}
