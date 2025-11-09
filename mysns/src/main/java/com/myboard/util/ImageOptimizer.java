package com.myboard.util;

import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;

/**
 * 이미지 경량화 유틸리티
 * 이미지를 리사이징하고 압축하여 파일 크기를 줄입니다.
 */
public class ImageOptimizer {
    
    // 최대 이미지 크기 (픽셀)
    private static final int MAX_WIDTH = 1920;
    private static final int MAX_HEIGHT = 1920;
    
    // JPEG 품질 (0.0 ~ 1.0, 낮을수록 파일 크기가 작아짐)
    private static final float JPEG_QUALITY = 0.85f;
    
    /**
     * 이미지 파일을 최적화합니다.
     * 
     * @param imageFile 이미지 파일
     * @return 최적화 성공 여부
     */
    public static boolean optimizeImage(File imageFile) {
        if (imageFile == null || !imageFile.exists()) {
            return false;
        }
        
        String fileName = imageFile.getName().toLowerCase();
        
        // 이미지 파일인지 확인
        if (!fileName.endsWith(".jpg") && !fileName.endsWith(".jpeg") 
            && !fileName.endsWith(".png") && !fileName.endsWith(".gif")) {
            return false; // 이미지가 아니면 최적화하지 않음
        }
        
        try {
            // 이미지 읽기
            BufferedImage originalImage = ImageIO.read(imageFile);
            if (originalImage == null) {
                return false;
            }
            
            int originalWidth = originalImage.getWidth();
            int originalHeight = originalImage.getHeight();
            
            // 이미지 크기 확인 (이미 작으면 최적화 스킵)
            if (originalWidth <= MAX_WIDTH && originalHeight <= MAX_HEIGHT) {
                // JPEG만 품질 조정
                if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
                    return compressJPEG(imageFile, originalImage);
                }
                return true; // PNG/GIF는 이미 작으면 그대로
            }
            
            // 리사이징 계산
            Dimension newSize = calculateSize(originalWidth, originalHeight);
            int newWidth = (int) newSize.getWidth();
            int newHeight = (int) newSize.getHeight();
            
            // 리사이징된 이미지 생성
            BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = resizedImage.createGraphics();
            
            // 고품질 리사이징 설정
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            
            g.drawImage(originalImage, 0, 0, newWidth, newHeight, null);
            g.dispose();
            
            // 이미지 저장
            if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
                return saveJPEG(imageFile, resizedImage);
            } else if (fileName.endsWith(".png")) {
                return ImageIO.write(resizedImage, "png", imageFile);
            } else if (fileName.endsWith(".gif")) {
                // GIF는 PNG로 변환 (더 나은 압축)
                String newFileName = imageFile.getAbsolutePath().replace(".gif", ".png");
                File newFile = new File(newFileName);
                boolean saved = ImageIO.write(resizedImage, "png", newFile);
                if (saved && newFile.exists()) {
                    imageFile.delete(); // 원본 GIF 삭제
                    return true;
                }
                return false;
            }
            
            return false;
            
        } catch (IOException e) {
            System.err.println("이미지 최적화 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 리사이징할 크기 계산
     */
    private static Dimension calculateSize(int originalWidth, int originalHeight) {
        double widthRatio = (double) MAX_WIDTH / originalWidth;
        double heightRatio = (double) MAX_HEIGHT / originalHeight;
        double ratio = Math.min(widthRatio, heightRatio);
        
        int newWidth = (int) (originalWidth * ratio);
        int newHeight = (int) (originalHeight * ratio);
        
        return new Dimension(newWidth, newHeight);
    }
    
    /**
     * JPEG 이미지 저장 (품질 조정)
     */
    private static boolean saveJPEG(File file, BufferedImage image) {
        try {
            Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");
            if (!writers.hasNext()) {
                return ImageIO.write(image, "jpg", file);
            }
            
            ImageWriter writer = writers.next();
            ImageWriteParam param = writer.getDefaultWriteParam();
            
            if (param.canWriteCompressed()) {
                param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
                param.setCompressionQuality(JPEG_QUALITY);
            }
            
            try (ImageOutputStream ios = ImageIO.createImageOutputStream(file)) {
                writer.setOutput(ios);
                writer.write(null, new javax.imageio.IIOImage(image, null, null), param);
            }
            writer.dispose();
            
            return true;
        } catch (IOException e) {
            System.err.println("JPEG 저장 중 오류: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * JPEG 이미지만 압축 (리사이징 없이)
     */
    private static boolean compressJPEG(File file, BufferedImage image) {
        return saveJPEG(file, image);
    }
    
    /**
     * 이미지 파일인지 확인
     */
    public static boolean isImageFile(String fileName) {
        if (fileName == null) {
            return false;
        }
        String lower = fileName.toLowerCase();
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") 
            || lower.endsWith(".png") || lower.endsWith(".gif")
            || lower.endsWith(".bmp") || lower.endsWith(".webp");
    }
}

