﻿package {	//import stuff	import flash.events.Event;	import com.greensock.*;	import org.papervision3d.lights.PointLight3D;	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;	import org.papervision3d.materials.utils.MaterialsList;	import org.papervision3d.objects.DisplayObject3D;	import org.papervision3d.objects.primitives.Cube;	import org.papervision3d.materials.BitmapFileMaterial;	import org.papervision3d.objects.primitives.*;	import org.papervision3d.materials.ColorMaterial;	import flash.geom.ColorTransform;	import flash.filters.*;	import flash.media.SoundMixer;	import flash.media.SoundChannel;	import org.papervision3d.objects.parsers.Collada;		import com.squidder.flar.FLARMarkerObj;	import com.squidder.flar.PVFLARBaseApplication;	import com.squidder.flar.events.FLARDetectorEvent;			import org.papervision3d.objects.primitives.Sphere;	import org.papervision3d.objects.parsers.DAE;		import flash.events.MouseEvent;	import flash.media.Video;    import flash.net.NetConnection;    import flash.net.NetStream;    import flash.events.NetStatusEvent; 	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.display.Sprite;	import flash.text.TextField;			import org.papervision3d.core.proto.DisplayObjectContainer3D;	import org.papervision3d.objects.primitives.Sphere;		import org.papervision3d.materials.WireframeMaterial;	import org.papervision3d.materials.VideoStreamMaterial;	import org.papervision3d.objects.primitives.Plane;	import org.papervision3d.materials.MovieMaterial;	import org.papervision3d.view.BasicView;		public class ScannerFMS extends PVFLARBaseApplication{		// variables that work throughout the code		private var _cubes : Array;		private var _lightPoint : PointLight3D;		private var _green:Cube;		private var cowSkin: BitmapFileMaterial;		private var cowMat: MaterialsList;		private var cow: Collada;		private var moo:mooSnd = new mooSnd();		private var mooChnl:SoundChannel = new SoundChannel();						private static const CAMERA_FILE:String = "assets/flar/camera_para.dat";				protected var plane:Plane;		protected var objectsContainer:DisplayObject3D;		protected var quality:uint = 16;		protected var netConnection:NetConnection;		protected var video:Video;		protected var netStream:NetStream;		protected var cube:Cube;		protected var imageMat:BitmapFileMaterial;		protected var video_cube:Cube;				protected var videoMat:VideoStreamMaterial;				protected var wmat:WireframeMaterial;				private var nc:NetConnection;		private var rtmpNow:String;		private var msg:String;		private var connectText:TextField;		private var posX:Number;		private var vidStream:Video;		private var nsIn:NetStream;		private var connected:Boolean;		public function ScannerFMS() {						_cubes = new Array();					// import the marker pattern			_markers = new Array();			_markers.push( new FLARMarkerObj( "assets/flar/snare.pat" , 16 , 50 , 80 ) );			_markers.push( new FLARMarkerObj( "assets/flar/kickdrum.pat" , 16 , 50 , 80 ) );			_markers.push( new FLARMarkerObj( "assets/flar/ride.pat" , 16 , 50 , 80 ) );			//_markers.push( new FLARMarkerObj( "assets/flar/snare.pat" , 16 , 50 , 80 ) );						super( );		}				override protected function _init( event : Event ) : void {			super._init( event );							_lightPoint = new PointLight3D( );			_lightPoint.y = 1000;			_lightPoint.z = -1000;					}		//detecting the marker		override protected function _detectMarkers() : void {						_resultsArray = _flarDetector.updateMarkerPosition( _flarRaster , 80 , .5 );						for ( var i : int = 0 ; i < _resultsArray.length ; i ++ ) {								var subResults : Array = _resultsArray[ i ];								for ( var j : * in subResults ) {										_flarDetector.getTransmationMatrix( subResults[ j ], _resultMat );					if ( _cubes[ i ][ j ] != null ) transformMatrix( _cubes[ i ][ j ] , _resultMat );				}							}									}						override protected function _handleMarkerAdded( event : FLARDetectorEvent ) : void {						_addCube( event.codeId , event.codeIndex );		}		override protected function _handleMarkerRemove( event : FLARDetectorEvent ) : void {				_removeCube( event.codeId , event.codeIndex );			}				//adding your objects				private function _addCube( id:int , index:int ) : void {					if ( _cubes[ id ] == null ) _cubes[ id ] = new Array();						if ( _cubes[ id ][ index ] == null ) {		//material set up							var dispObj : DisplayObject3D = new DisplayObject3D();								if (id==0){										//Create light source for shade material					var light:PointLight3D = new PointLight3D();					light.x = 1000;					light.y = 1000;					light.z = 1000;									// create client for netStream object					var customClient:Object = new Object();					netConnection = new NetConnection();					netConnection.connect(null); 								netStream = new NetStream(netConnection);					netStream.client = customClient;					netStream.play("assets/flar/whiteOak2.flv");					// add listener for net status to control video looping					//netStream.addEventListener(NetStatusEvent.NET_STATUS, statusHandler); 					video = new Video();					video.width = 300;					video.height = 300;					video.smoothing = true;					//video.deblocking = 5;					video.attachNetStream(netStream);					//Create Materials					videoMat = new VideoStreamMaterial(video, netStream, true, true);					wmat = new WireframeMaterial(0xff0000);					wmat.doubleSided = true;								//Create objects					//objectsContainer = new DisplayObject3D();					//plane = new Plane(wmat, 100, 100,1,1);					video_cube = new Cube(new MaterialsList( { front: videoMat } ), 512, 1, 288, quality, quality, quality, 0);								//Position elements											video_cube.x = -40;					 video_cube.z += 30;					video_cube.y = -30;					dispObj.z =15;								//Add objects to my container					//objectsContainer.addChild(vni_logo_cube)					dispObj.addChild(video_cube);								//Add to base					//_baseNode.addChild(plane);					_baseNode.addChild(dispObj);								} else if(id==1){										//Create light source for shade material					var light:PointLight3D = new PointLight3D();					light.x = 1000;					light.y = 1000;					light.z = 1000;								//NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;										rtmpNow="rtmpe://cissrv0.uwsp.edu/WDMD302Justin";									nc=new NetConnection();					nc.addEventListener(NetStatusEvent.NET_STATUS,checkCon);										nc.connect(rtmpNow);									} 								function checkCon(myConn:NetStatusEvent):void{					trace(myConn.info.code);					connected=myConn.info.code == "NetConnection.Connect.Success";					if(connected){						//nsOut=new NetStream(nc);						//nsOut.attachAudio(mic);						//nsOut.attachCamera(cam);						//nsOut.publish("left","live");						nsIn=new NetStream(nc);												nsIn.addEventListener(NetStatusEvent.NET_STATUS,checkCon);						//nsIn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);						setVideo();						//nsIn.play("right");										}				}								function setVideo():void{					//vidLocal=new Video(cam.width, cam.height);					//addChild(vidLocal);					//vidLocal.x=15; vidLocal.y=30;					//vidLocal.attachCamera(cam);					nsIn.client = new Object();					vidStream =new Video(stage.stageWidth, stage.stageHeight);					vidStream.attachNetStream(nsIn);										nsIn.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler)										addChild(vidStream);					trace("addChild(vidStream)");					nsIn.play("InfoDesk");				}								function netStatusHandler( event:NetStatusEvent ) :void                 {                        if(event.info.code == "NetStream.Play.Stop")                         {                                 //netStream.seek(0); 								removeChild(vidStream);                        } 						else if (event.info.code == "NetStream.Buffer.Flush")						{														trace("removed vidStream");							removeChild(vidStream);													}                } 												_cubes[ id ][ index ] = dispObj;							} 							_baseNode.addChild( _cubes[ id ][ index ] );					}				//The remove cube function. Gets activated once a marker is removed		private function _removeCube( id:int , index:int ) : void {						//removeChild(vidStream);			if ( _cubes[ id ] == null ) _cubes[ id ] = new Array();			if ( _cubes[ id ][ index ] != null ) {								_baseNode.removeChild( _cubes[ id ][ index ] );							}		}					}}