package wx.lab.mock.reflect;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
// --- <<IS-END-IMPORTS>> ---

public final class j

{
	// ---( internal utility methods )---

	final static j _instance = new j();

	static j _newInstance() { return new j(); }

	static j _cast(Object o) { return (j)o; }

	// ---( server methods )---




	public static final void reflectPayloadWithDelay (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(reflectPayloadWithDelay)>> ---
		// @sigtype java 3.5
		// [i] field:0:required payloadStringIn
		// [i] field:0:optional sleepMillis
		// [o] field:0:required payloadStringOut
		// [o] field:0:required totalMillis
		// pipeline
		
		long startMillis=System.currentTimeMillis();
		
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	payloadStringIn = IDataUtil.getString( pipelineCursor, "payloadStringIn" );
			String	sleepMillis = IDataUtil.getString( pipelineCursor, "sleepMillis" );
		pipelineCursor.destroy();
		
		long millis = 0;
		
		try{
			millis = Long.parseLong(sleepMillis);
		}catch(Exception e){
			millis = 0;
		}
		
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			// we don't care
		}
		// pipeline
		IDataCursor pipelineCursor_1 = pipeline.getCursor();
		IDataUtil.put( pipelineCursor_1, "payloadStringOut", payloadStringIn );
		IDataUtil.put( pipelineCursor_1, "totalMillis", "" + (System.currentTimeMillis() - startMillis) );
		pipelineCursor_1.destroy();
		
			
		// --- <<IS-END>> ---

                
	}
}

