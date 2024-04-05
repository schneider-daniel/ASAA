from pyueye import ueye
import numpy as np
import cv2
import ctypes

def main():
    # Variables
    hCam = ueye.HIDS(1)  # 0: first available camera;  1-254: The camera with the specified camera ID
    sInfo = ueye.SENSORINFO()
    cInfo = ueye.CAMINFO()
    pcImageMemory = ueye.c_mem_p()
    MemID = ueye.int()
    rectAOI = ueye.IS_RECT()

    fps = 24
    save_path = r'./video/'
    video_file = "video.mp4"

    pitch = ueye.INT()
    nBitsPerPixel = ueye.INT(8)  # 24: bits per pixel for color mode; take 8 bits per pixel for monochrome
    channels = 3  # 3: channels for color mode(RGB); take 1 channel for monochrome
    m_nColorMode = ueye.INT(3)  # Y8/RGB16/RGB24/REG32
    bytes_per_pixel = int(nBitsPerPixel / 8)

    print("START \n")

    # Starts the driver and establishes the connection to the camera
    nRet = ueye.is_InitCamera(hCam, None)
    if nRet != ueye.IS_SUCCESS:
        print("is_InitCamera ERROR")
        nRet = ueye.is_GetCameraInfo(hCam, cInfo)
        if nRet != ueye.IS_SUCCESS:
            print("is_GetCameraInfo ERROR")

    # You can query additional information about the sensor type used in the camera
    nRet = ueye.is_GetSensorInfo(hCam, sInfo)
    if nRet != ueye.IS_SUCCESS:
        print("is_GetSensorInfo ERROR")

    nRet = ueye.is_ResetToDefault(hCam)
    if nRet != ueye.IS_SUCCESS:
        print("is_ResetToDefault ERROR")

    # Set config file
    pParam = ueye.wchar_p()
    pParam.value = r"cfg\ids_3180.ini"
    ueye.is_ParameterSet(hCam, ueye.IS_PARAMETERSET_CMD_LOAD_FILE, pParam, 0)

    # You can query additional information about the sensor type used in the camera
    nRet = ueye.is_SetFrameRate(hCam, ctypes.c_double(fps), ctypes.c_double(fps))

    ueye.is_GetColorDepth(hCam, nBitsPerPixel, m_nColorMode)
    bytes_per_pixel = int(nBitsPerPixel / 8)
    nRet = ueye.is_SetWhiteBalance(hCam, 2)

    nRet = ueye.is_AOI(hCam, ueye.IS_AOI_IMAGE_GET_AOI, rectAOI, ueye.sizeof(rectAOI))
    width = rectAOI.s32Width
    height = rectAOI.s32Height

    # Prints out some information about the camera and the sensor
    print("Camera model:\t\t", sInfo.strSensorName.decode('utf-8'))
    print("Camera serial no.:\t", cInfo.SerNo.decode('utf-8'))
    print("Maximum image width:\t", width)
    print("Maximum image height:\t", height)
    print()

    # Allocates an image memory for an image having its dimensions defined by width and height and its color depth defined by nBitsPerPixel
    nRet = ueye.is_AllocImageMem(hCam, width, height, nBitsPerPixel, pcImageMemory, MemID)
    if nRet != ueye.IS_SUCCESS:
        print("is_AllocImageMem ERROR")
    else:
        # Makes the specified image memory the active memory
        nRet = ueye.is_SetImageMem(hCam, pcImageMemory, MemID)
        if nRet != ueye.IS_SUCCESS:
            print("is_SetImageMem ERROR")
        else:
            # Set the desired color mode
            nRet = ueye.is_SetColorMode(hCam, m_nColorMode)

    # Activates the camera's live video mode (free run mode)
    nRet = ueye.is_CaptureVideo(hCam, ueye.IS_DONT_WAIT)
    if nRet != ueye.IS_SUCCESS:
        print("is_CaptureVideo ERROR")

    # Enables the queue mode for existing image memory sequences
    nRet = ueye.is_InquireImageMem(hCam, pcImageMemory, MemID, width, height, nBitsPerPixel, pitch)
    if nRet != ueye.IS_SUCCESS:
        print("is_InquireImageMem ERROR")
    else:
        print("Press q to leave the programm")

    # Configure video writer
    out = cv2.VideoWriter(save_path + video_file, cv2.VideoWriter_fourcc('m', 'p', '4', 'v'), fps, (width.value, height.value))
    
    # Continuous image display
    while (nRet == ueye.IS_SUCCESS):
        array = ueye.get_data(pcImageMemory, width, height, nBitsPerPixel, pitch, copy=False)

        frame = np.reshape(array, (height.value, width.value, bytes_per_pixel))
        frame = cv2.cvtColor(frame, cv2.COLOR_BGRA2BGR)
        out.write(frame)

        # Downscale the image to display
        frame = cv2.resize(frame, (648,512), interpolation=cv2.INTER_AREA)
        cv2.imshow("Live video", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # Close VideoWriter
    out.release()
    ueye.is_FreeImageMem(hCam, pcImageMemory, MemID)
    ueye.is_ExitCamera(hCam)
    cv2.destroyAllWindows()

    print()
    print("END")

if __name__=='__main__':
    main()