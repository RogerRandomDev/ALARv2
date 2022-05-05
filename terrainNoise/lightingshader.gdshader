shader_type canvas_item;

void fragment() {
	float closest=1024.;
	float nearbyEmpty=1.;
	for(float x=-6.;x<7.;x++){for(float y=-6.;y<7.;y++){
		float col=texture(TEXTURE,UV+vec2(x,y)*TEXTURE_PIXEL_SIZE).a;
		if(col>=1.){
			closest=min(closest,(pow(x,2.)+pow(y,2.))/col);
			nearbyEmpty++;
		}
	}}
	COLOR.a=sqrt(closest)/5.-0.35;
}
