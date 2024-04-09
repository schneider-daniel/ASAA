import cv2
import os

def save_frames_from_video(video_path, output_folder, every_img):
    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Open the video file
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        print("Error: Could not open the video file")
        return

    # Loop through the video frames and save them as images
    frame_count = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # Save the frame as an image
        frame_count += 1
        frame_filename = os.path.join(output_folder, f"{frame_count:05d}.png")
        if frame_count % every_img == 0:
            cv2.imwrite(frame_filename, frame)

    # Release the video capture object
    cap.release()

    print(f"Frames saved: {frame_count}")

if __name__ == "__main__":
    video_path = "./video/20240408_09-14-54.mp4"
    output_folder = "./img/calib"
    every_img = 24
    save_frames_from_video(video_path, output_folder, every_img)
