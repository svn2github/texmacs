/*
   Source File : PDFStream.cpp


   Copyright 2011 Gal Kahana PDFWriter

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   
*/
#include "PDFStream.h"
#include "IObjectsContextExtender.h"
#include "InputStringBufferStream.h"
#include "OutputStreamTraits.h"

PDFStream::PDFStream(bool inCompressStream,
					 IByteWriterWithPosition* inOutputStream,
					 ObjectIDType inExtentObjectID,
					 IObjectsContextExtender* inObjectsContextExtender)
{
	mExtender = inObjectsContextExtender;
	mCompressStream = inCompressStream;
	mExtendObjectID = inExtentObjectID;	
	mStreamStartPosition = inOutputStream->GetCurrentPosition();
	mOutputStream = inOutputStream;
	mStreamLength = 0;
    mStreamDictionaryContextForDirectExtentStream = NULL;


	if(mCompressStream)
	{
		if(mExtender && mExtender->OverridesStreamCompression())
		{
			mWriteStream = mExtender->GetCompressionWriteStream(inOutputStream);
		}
		else
		{
			mFlateEncodingStream.Assign(inOutputStream);
			mWriteStream = &mFlateEncodingStream;
		}
	}
	else
		mWriteStream = inOutputStream;

}

PDFStream::PDFStream(
          bool inCompressStream,
          IByteWriterWithPosition* inOutputStream,
          DictionaryContext* inStreamDictionaryContextForDirectExtentStream,
          IObjectsContextExtender* inObjectsContextExtender)
{
	mExtender = inObjectsContextExtender;
	mCompressStream = inCompressStream;
	mExtendObjectID = 0;	
	mStreamStartPosition = 0;
	mOutputStream = inOutputStream;
	mStreamLength = 0;
    mStreamDictionaryContextForDirectExtentStream = inStreamDictionaryContextForDirectExtentStream;
    
    mTemporaryOutputStream.Assign(&mTemporaryStream);
    
	if(mCompressStream)
	{
		if(mExtender && mExtender->OverridesStreamCompression())
		{
			mWriteStream = mExtender->GetCompressionWriteStream(&mTemporaryOutputStream);
		}
		else
		{
			mFlateEncodingStream.Assign(&mTemporaryOutputStream);
			mWriteStream = &mFlateEncodingStream;
		}
	}
	else
		mWriteStream = &mTemporaryOutputStream;
    
}


PDFStream::~PDFStream(void)
{
    
}

IByteWriter* PDFStream::GetWriteStream()
{
	return mWriteStream;
}

void PDFStream::FinalizeStreamWrite()
{
	if(mExtender && mExtender->OverridesStreamCompression() && mCompressStream)
		mExtender->FinalizeCompressedStreamWrite(mWriteStream);
	mWriteStream = NULL;
	if(mCompressStream)
		mFlateEncodingStream.Assign(NULL);  // this both finished encoding any left buffers and releases ownership from mFlateEncodingStream
    
    // different endings, depending if direct stream writing or not
    if(mExtendObjectID == 0)
    {
        mStreamLength = mTemporaryStream.GetCurrentWritePosition();
    }
    else 
    {
        mStreamLength = mOutputStream->GetCurrentPosition()-mStreamStartPosition;
        mOutputStream = NULL;
    }
}

LongFilePositionType PDFStream::GetLength()
{
	return mStreamLength;
}

bool PDFStream::IsStreamCompressed()
{
	return mCompressStream;
}

ObjectIDType PDFStream::GetExtentObjectID()
{
	return mExtendObjectID;
}

DictionaryContext* PDFStream::GetStreamDictionaryForDirectExtentStream()
{
    return mStreamDictionaryContextForDirectExtentStream;
}

void PDFStream::FlushStreamContentForDirectExtentStream()
{
    mTemporaryStream.pubseekoff(0,std::ios_base::beg);
    
    // copy internal temporary stream to output
    InputStringBufferStream inputStreamForWrite(&mTemporaryStream);
    OutputStreamTraits streamCopier(mOutputStream);
    streamCopier.CopyToOutputStream(&inputStreamForWrite);
    
    mTemporaryStream.str();
    mOutputStream = NULL;
}

